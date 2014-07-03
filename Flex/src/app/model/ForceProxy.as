package app.model
{	
	import mx.collections.ArrayCollection;
	
	import app.model.vo.ForceVO;
	import app.model.vo.RopewayStationVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class ForceProxy extends Proxy
	{
		public static const NAME:String = "ForceProxy";
		
		public function ForceProxy()
		{
			super(NAME, new ArrayCollection);			
		}
		
		public function get list():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		override public function onRegister():void
		{
			/*var rsProxy:RopewayStationProxy = facade.retrieveProxy(RopewayStationProxy.NAME) as RopewayStationProxy;
			
			for each(var rs:RopewayStationVO in rsProxy.list)
			{
				var force:ForceVO = new ForceVO;
				force.ropewayStation = rs;
				list.addItem(force);
			}*/
		}
		
		public function Update(force:ForceVO):void
		{
			for each(var item:ForceVO in list)
			{
				if(item.ropewayStation.fullName == force.ropewayStation.fullName)
				{
					CustomUtil.CopyProperties(force,item);
					break;
				}
			}
		}
	}
}