package app.model
{
	import com.adobe.utils.DateUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.globalization.DateTimeFormatter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
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
			if(!bracket.wind.hasHistory)
			{
				bracket.wind.newHistory();
				
				var day:Date = new Date(date.fullYear,date.month,date.date);
				
				var token:AsyncToken = sendNoBusy("T_JC_WindSpeedHisBLL_GetModelList",rwName,bracketId,day,DateUtil.addDateTime('d',1,day));
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
		
		public function WindValueGetPageData(bracket:BracketVO,sTime:Date,eTime:Date,pageIndex:int,pageSize:int):AsyncToken
		{
			return send("T_JC_WindSpeedHisBLL_GetPageData",bracket.ropeway.fullName,bracket.bracketId,sTime,eTime,pageIndex,pageSize);
		}
		
		public function WindValueGetModelList(bracket:BracketVO,sTime:Date,eTime:Date):AsyncToken
		{
			return send("T_JC_WindSpeedHisBLL_GetModelList",bracket.ropeway.fullName,bracket.bracketId,sTime,eTime);
		}
		
		public function WindValueExport(bracket:BracketVO,sTime:Date,eTime:Date):void
		{			
			var df:DateTimeFormatter = new DateTimeFormatter("zh_CN");
			//df.setDateTimePattern("YYYY/MM/dd HH:mm:ss");
			
			const xltname:String = "历史风速风向";
						
			var urlVar:URLVariables = new URLVariables;
			urlVar.xltname = xltname;
			urlVar.bracketId = bracket.bracketId;
			urlVar.rwName = bracket.ropeway.fullName;
			urlVar.sTime = df.format(sTime);
			urlVar.eTime = df.format(eTime);
			
			export("WindValueExport",xltname + ".xls",urlVar);
		}
	}
}