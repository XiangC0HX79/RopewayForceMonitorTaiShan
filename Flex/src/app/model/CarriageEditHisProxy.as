package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.CarriageEditHisVO;
	import app.model.vo.CarriageVO;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class CarriageEditHisProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "CarriageEditHisProxy";
		
		public function CarriageEditHisProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get colBaseinfoHis():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function GetHistory(baseinfo:CarriageVO):void
		{
			var where:String = "RopeCode = '" + baseinfo.ropewayId + "'";
			
			send("RopeDete_RopeCarriageRelaHis_GetList",onGetHistory,where);
		}
		
		private function onGetHistory(event:ResultEvent):void
		{
			var source:Array = [];
			for each(var o:ObjectProxy in event.result)
			{
				source.push(new CarriageEditHisVO(o));
			}
			colBaseinfoHis.source = source;
		}
	}
}