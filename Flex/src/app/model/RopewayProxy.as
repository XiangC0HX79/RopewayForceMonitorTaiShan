package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RopewayProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayProxy";
		
		public static var alarmVal:Number = 50;
		
		public function RopewayProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get colRopeway():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function InitRopewayDict():void
		{
			send("RopeDeteInfoToday_GetList",onInitRopewayDict,"");
		}
		
		private function onInitRopewayDict(event:ResultEvent):void
		{
			var arr:Array = [];
			for each(var o:ObjectProxy in event.result)
			{
				var rw:RopewayVO = new RopewayVO(o);		
				rw.aveValue = Math.round(rw.totalValue / rw.switchFreq);
				arr.push(rw);
			}
			
			colRopeway.source = arr;
			
			rw = GetRopewayByStation("桃花源驱动站");
			
			if(rw)
			{
				var token:AsyncToken = LoadRopeWayForceHis(rw);
				token.addResponder(new AsyncResponder(onInitRopewayComplete,function(fault:FaultEvent,t:Object):void{}));
				token.ropeway = rw;
			}
			else
			{
				sendNotification(ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE);				
			}
		}
		
		private function onInitRopewayComplete(event:ResultEvent,t:Object):void
		{			
			sendNotification(ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,event.token.ropeway);
		}
		
		/*private function onRopeDeteValueHis_GetList(event:ResultEvent):void
		{
			for each(var i:ObjectProxy in event.result)
			{
				var rf:RopewayForceVO = new RopewayForceVO(i);
				AddRopeway(rf);
			}
						
			sendNotification(ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE);
		}*/
		
		public function GetRopewayByForce(ropewayForce:RopewayForceVO):RopewayVO
		{
			for each(var r:RopewayVO in colRopeway)
			{
				if((r.ropewayId == ropewayForce.ropewayId)
					&& (r.ropewayStation == ropewayForce.fromRopeStation))	
				{				
					return r;
				}
			}
			
			return null;
		}
		
		public function PushRopewayForce(ropeway:RopewayVO,ropewayForce:RopewayForceVO):void
		{			
			if(ropeway.ropewayHistory.length > 0)
			{						
				var prerf:RopewayForceVO = ropeway.ropewayHistory[ropeway.ropewayHistory.length-1];
				if(Math.abs(ropewayForce.ropewayForce - prerf.ropewayForce) > RopewayProxy.alarmVal)
				{
					ropewayForce.alarm = 2;
					ropeway.alarm = 2;
				}
			}
			
			if(ropeway.yesterdayAve > 0)
			{						
				if(Math.abs(ropewayForce.ropewayForce - ropeway.yesterdayAve) > RopewayProxy.alarmVal)
				{
					ropewayForce.alarm = 1;
					ropeway.alarm = 1;
				}
			}
			
			ropeway.ropewayRFIDEletric = ropewayForce.eletric;
			ropeway.deteValue = ropewayForce.ropewayForce;
			ropeway.humidity = ropewayForce.ropewayHumidity;
			ropeway.temperature = ropewayForce.ropewayTemp;
			ropeway.deteDate = ropewayForce.ropewayTime;
			ropeway.valueUnit = ropewayForce.ropewayUnit;
			ropeway.switchFreq++;
			ropeway.switchFreqTotal ++;
			ropeway.totalValue += ropewayForce.ropewayForce;
			ropeway.aveValue = Math.round(ropeway.totalValue / ropeway.switchFreq);
			
			ropeway.ropewayHistory.push(ropewayForce);
		}
		
		public function GetRopewayByStation(station:String):RopewayVO
		{
			var rt:RopewayVO = null;
			for each(var r:RopewayVO in colRopeway)
			{
				if((r.ropewayStation == station)
					&& (r.deteDate.toDateString() == (new Date).toDateString()))
				{
					if(!rt)
					{
						rt = r;
					}
					else if(rt.deteDate.time < r.deteDate.time)
					{
						rt = r;
					}
				}
			}
			
			return rt;
		}
		
		public function LoadRopeWayForceHis(ropeway:RopewayVO):AsyncToken
		{
			var where:String = "RopeCode = '" + ropeway.ropewayId + "' AND FromRopeStation = '" + ropeway.ropewayStation + "' AND DATEDIFF(D,DeteDate,GETDATE()) = 0";
			
			var token:AsyncToken = send("RopeDeteValueHis_GetList",onLoadRopeWayForceHis,where);
			token.ropeway = ropeway;
			return token;
		}
		
		private function onLoadRopeWayForceHis(event:ResultEvent):void
		{			
			var ropeway:RopewayVO = event.token.ropeway;
			ropeway.ropewayHistory = [];
			
			for each(var o:ObjectProxy in event.result)
			{
				var rf:RopewayForceVO = new RopewayForceVO(o);
				
				if(ropeway.ropewayHistory.length > 0)
				{						
					var prerf:RopewayForceVO = ropeway.ropewayHistory[ropeway.ropewayHistory.length-1];
					if(Math.abs(rf.ropewayForce - prerf.ropewayForce) > RopewayProxy.alarmVal)
					{
						rf.alarm = 2;
						ropeway.alarm = 2;
					}
				}
				
				if(ropeway.yesterdayAve > 0)
				{						
					if(Math.abs(rf.ropewayForce - ropeway.yesterdayAve) > RopewayProxy.alarmVal)
					{
						rf.alarm = 1;
						ropeway.alarm = 1;
					}
				}
				
				ropeway.ropewayHistory.push(rf);
			}
		}
		
		public function FindRopewayByForce(ropewayForce:RopewayForceVO):AsyncToken
		{
			return send("RopeDeteInfoToday_GetModel",null,ropewayForce.toString());
		}
				
		public function GetRopewayCount(station:String):Number
		{
			var count:Number = 0;
			for each(var r:RopewayVO in colRopeway)
			{
				if(r.ropewayStation == station)
				{
					count++;
				}
			}
			
			return count;
		}
	}
}