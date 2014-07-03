package app.model
{
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import app.ApplicationFacade;
	import app.model.vo.BracketVO;
	import app.model.vo.InternalVO;
	import app.model.vo.WindVO;
	import app.model.vo.WindValueVO;
	
	use namespace InternalVO;
	
	public class WindProxy extends WebServiceProxy
	{
		public static const NAME:String = "WindProxy";
		
		public function WindProxy()
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
			if(!bracket.wind.history)
			{
				bracket.wind.history = new ArrayCollection;
				
				var token:AsyncToken = sendNoBusy("GetWindHistroy",rwName,bracketId,date);
				token.addResponder(new AsyncResponder(onGetWindHistroy,function (event:FaultEvent,t:Object):void{}));
				token.wind = bracket.wind;
				token.windValue = windValue;
				return token;
			}
			else
			{
				bracket.wind.PushWind(windValue);
				return null;
			}
		}
		
		private function onGetWindHistroy(event:ResultEvent,t:Object):void
		{
			var wind:WindVO = WindVO(event.token.wind);
			
			for each(var item:ObjectProxy in event.result)
			{
				var windValue:WindValueVO = new WindValueVO;
				windValue.date = item.DeteDate;
				windValue.dir = item.WinDirection;
				windValue.speed = item.WindSpeed;
				wind.UnshiftWind(windValue);
			}
			
			wind.PushWind(WindValueVO(event.token.windValue));
		}
	}
}