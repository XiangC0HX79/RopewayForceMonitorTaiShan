package app.model
{
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.vo.RopewayStationVO;
	import app.model.vo.SurroundingTempVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	public class SurroundingProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String = "SurroundingProxy";
		public static const SRNAME:String = "SurroundingProxySR";
		
		public function SurroundingProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get list():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function load():void
		{
			list.removeAll();
			
			var rsProxy:RopewayStationProxy = facade.retrieveProxy(RopewayStationProxy.NAME) as RopewayStationProxy;
			for each(var rs:RopewayStationVO in rsProxy.list)
			{
				var st:SurroundingTempVO = new SurroundingTempVO;
				st.ropewayStation = rs;
				list.addItem(st);
			}
			
			sendNotification(ApplicationFacade.NOTIFY_SURROUNDING_LOADED,NAME);
		}
		
		public function retrieveSurroundingTemp(rs:RopewayStationVO):SurroundingTempVO
		{
			for each(var item:SurroundingTempVO in list)
			{
				if(item.ropewayStation.fullName == rs.fullName)
					return item;
			}
			
			return null;
		}
		
		public function Update(st:SurroundingTempVO):void
		{			
			CustomUtil.CopyProperties(st,retrieveSurroundingTemp(st.ropewayStation));	
		}
	}
}