package app.model
{
	import app.model.RopewayProxy;
	import app.model.vo.RopewayAlarmVO;
	import app.model.vo.RopewayVO;
	
	import mx.collections.ArrayCollection;
	import mx.messaging.AbstractConsumer;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RopewayAlarmProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayAlarmProxy";
		
		public function RopewayAlarmProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get arr():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function InitAlarmArr(station:String):void
		{
			
		}
		
		private function AddRopewayAlarm(ropewayAlarm:RopewayAlarmVO):void
		{
			
		}
		
		public function IsRopewayAlarm(ropeway:RopewayVO):void
		{
			/*var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			var r:RopewayVO = proxy.ropewayDict[ropeway.ropewayId] as RopewayVO;
			var obj:Object = new Object();
			if(!r.ropewayHistory[r.ropewayHistory.length-2].ropewayForce 
				|| ropeway.ropewayForce >=r.ropewayHistory[r.ropewayHistory.length-2].ropewayForce + 50
				|| ropeway.ropewayForce <=r.ropewayHistory[r.ropewayHistory.length-2].ropewayForce - 50)
			{
				obj.RoapCode = ropeway.ropewayId;
				obj.AlarmDatetime = ropeway.ropewayTime;
				obj.AlarmType = "超过前次值";
				var ra:RopewayAlarmVO = new RopewayAlarmVO(obj);
				arr.addItemAt(ra,0);
			}
			if(!r.ropewayHistory[r.ropewayHistory.length-2].ropewayForce 
				|| ropeway.ropewayForce >=ropeway.yesterdayAve + 50
				|| ropeway.ropewayForce <=ropeway.yesterdayAve - 50)
			{
				obj.RoapCode = ropeway.ropewayId;
				obj.AlarmDatetime = ropeway.ropewayTime;
				obj.AlarmType = "超过昨日平均值";
				var ra2:RopewayAlarmVO = new RopewayAlarmVO(obj);
				arr.addItemAt(ra2,0);
			}*/
		}
	}
}