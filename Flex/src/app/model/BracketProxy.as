package app.model
{
	import com.adobe.utils.DateUtil;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import app.model.vo.BracketVO;
	import app.model.vo.InternalVO;
	import app.model.vo.WindValueVO;
		
	use namespace InternalVO;
	
	public class BracketProxy extends WebServiceProxy
	{
		public static const NAME:String = "BracketProxy";
		
		public function BracketProxy()
		{
			super(NAME);
		}
						
		public function AddItem(rwName:String,bracketId:int,date:Date,speed:Number,dir:Number):AsyncToken
		{
			var windValue:WindValueVO = new WindValueVO;
			windValue.date = date;
			windValue.speed = speed;
			windValue.dir = dir;
			
			var bracket:BracketVO = BracketVO.getName(rwName,bracketId);
			if(!bracket.hasHistory)
			{
				bracket.newHistory();
				
				var day:Date = new Date(date.fullYear,date.month,date.date);
				
				var token:AsyncToken = sendNoBusy("T_JC_WindSpeedHisBLL_GetModelList",rwName,bracketId,day,date);
				token.bracket = bracket;
				token.windValue = windValue;
				token.addResponder(new AsyncResponder(onGetWindHistroy,function (event:FaultEvent,t:Object):void{}));
				return token;
			}
			else
			{
				bracket.PushWind(windValue);
				return null;
			}
		}
		
		private function onGetWindHistroy(event:ResultEvent,t:Object):void
		{
			var bracket:BracketVO = BracketVO(event.token.bracket);
			
			for each(var item:ObjectProxy in event.result)
			{
				var windValue:WindValueVO = new WindValueVO;
				windValue.date = item.DeteDate;
				windValue.dir = item.WinDirection;
				windValue.speed = item.WindSpeed;
				bracket.PushWind(windValue,false);
			}
			
			bracket.PushWind(WindValueVO(event.token.windValue));
		}
	}
}