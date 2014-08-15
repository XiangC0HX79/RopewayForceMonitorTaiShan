package app.model
{
	import com.adobe.serialization.json.JSON;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import app.model.vo.EngineTempVO;
	import app.model.vo.EngineVO;
	import app.model.vo.InternalVO;
	
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	use namespace InternalVO;
	
	public class EngineProxy extends WebServiceProxy implements ILoadupProxy
	{
		public static const NAME:String = "EngineProxy";
		public static const SRNAME:String = "EngineProxySR";
		
		public static const LOADED:String = "EngineProxy/Loaded";
		public static const FAILED:String = "EngineProxy/Failed";
		
		public function EngineProxy()
		{
			super(NAME);
		}
						
		public function load():void
		{			
			var token:AsyncToken = sendNoBusy("T_JC_Temperature_Load");
			token.addResponder(new AsyncResponder(onLoad,onFault));
		}		
		
		private function onFault(event:FaultEvent,t:Object = null):void
		{
			sendNotification(FAILED,NAME);			
		}
							
		private function onLoad(event:ResultEvent,t:Object = null):void
		{
			var json:* = JSON.decode(event.result as String);
			
			for each(var device:* in json.DeviceComm)
			{
				var engine:EngineVO = EngineVO.getNamed(device.RopeWayName,int(device.Pos));
				engine.deviceName = device.DeviceName;
			}
			
			for each(var statis:* in json.Statis)
			{				
				engine = EngineVO.getNamed(statis.FromRopeWay,int(statis.Pos));
				engine.minTemp = statis.Min;
				engine.maxTemp = statis.Max;
				engine.totalCount = statis.Count;
				engine.totalValue = statis.Sum;
			}
			
			for each(var item:* in json.Temperature)
			{
				var et:EngineTempVO = new EngineTempVO;
				et.date = new Date(Date.parse(item.DeteDate));
				et.temp = item.DeteValue;
				
				EngineVO.getNamed(item.FromRopeWay,item.Pos).PushItem(et);
			}
			
			sendNotification(LOADED,NAME);
		}
		
		public function AddItem(rwName:String,date:Date,pos:int,temp:Number):void
		{						
			var et:EngineTempVO = new EngineTempVO;
			et.date = date;
			et.temp = temp;
			
			EngineVO.getNamed(rwName,pos).PushItem(et);
		}
	}
}