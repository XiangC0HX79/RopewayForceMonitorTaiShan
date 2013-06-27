package app.model
{
	import mx.collections.ArrayCollection;
	
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
	}
}