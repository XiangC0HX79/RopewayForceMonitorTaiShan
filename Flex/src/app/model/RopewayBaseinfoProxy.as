package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayBaseinfoVO;
	import app.model.vo.RopewayForceVO;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.utils.ObjectProxy;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RopewayBaseinfoProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayBaseinfoProxy";
		
		public function RopewayBaseinfoProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get colBaseinfo():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function GetBaseInfo(fromRopeWay:String):void
		{
			
		}
		
		public function NewBaseInfo(fromRopeWay:String,ropewayId:String,ropewayCarId:String,ropewayRFID:String):void
		{
			var info:RopewayBaseinfoVO = new RopewayBaseinfoVO;
			info.ropewayId = ropewayId;
			info.ropewayCarId = ropewayCarId;
			info.ropewayRFID = ropewayRFID;
			info.fromRopeWay = fromRopeWay;
			info.isUse = true;
			
			colBaseinfo.addItem(info);
		}
		
		public function EditBaseInfo(baseInfo:RopewayBaseinfoVO):void
		{
		}
		
		public function DelBaseInfo(baseInfo:RopewayBaseinfoVO):void
		{
			colBaseinfo.removeItemAt(colBaseinfo.getItemIndex(baseInfo));
		}
	}
}