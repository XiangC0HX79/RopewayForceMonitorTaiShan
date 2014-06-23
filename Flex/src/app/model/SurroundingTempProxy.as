package app.model
{
	import mx.collections.ArrayCollection;
	
	import app.model.vo.RopewayStationVO;
	import app.model.vo.SurroundingTempVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class SurroundingTempProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "SurroundingTempProxy";
		
		public function SurroundingTempProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get list():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		override public function onRegister():void
		{
			var rsProxy:RopewayStationProxy = facade.retrieveProxy(RopewayStationProxy.NAME) as RopewayStationProxy;
			for each(var rs:RopewayStationVO in rsProxy.list)
			{
				var st:SurroundingTempVO = new SurroundingTempVO;
				st.ropewayStation = rs;
				list.addItem(st);
			}
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