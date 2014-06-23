package app.model
{
	import mx.collections.ArrayCollection;
	
	import app.model.vo.RopewayStationVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class RopewayStationProxy extends Proxy
	{
		public static const NAME:String = "RopewayStationProxy";
		
		public function RopewayStationProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get list():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		override public function onRegister():void
		{
			var ropewayProxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			for each(var rw:RopewayVO in ropewayProxy.list)
			{
				list.addItem(new RopewayStationVO(rw.shortName + RopewayStationVO.FIRST));
				list.addItem(new RopewayStationVO(rw.shortName + RopewayStationVO.SECOND));
			}
		}
	}
}