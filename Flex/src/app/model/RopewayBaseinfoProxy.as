package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayBaseinfoVO;
	import app.model.vo.RopewayForceVO;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
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
			var where:String = "FromRopeWay = '" + fromRopeWay + "'";
			
			send("RopeDete_RopeCarriageRela_GetList",onGetBaseInfo,where);
		}
		
		private function onGetBaseInfo(event:ResultEvent):void
		{
			var source:Array = [];
			for each(var o:ObjectProxy in event.result)
			{
				source.push(new RopewayBaseinfoVO(o));
			}
			colBaseinfo.source = source;
		}
		
		public function NewBaseInfo(baseInfo:RopewayBaseinfoVO):void
		{
			var token:AsyncToken = send("RopeDete_RopeCarriageRela_New",onNewBaseInfo,baseInfo.toString());
			token.info = baseInfo;
		}
		
		private function onNewBaseInfo(event:ResultEvent):void
		{			
			var info:RopewayBaseinfoVO = event.token.info;
			
			if(event.result > 0)
			{
				info.id = Number(event.result);
				
				colBaseinfo.addItem(info);
				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"吊箱'" + info.ropewayCarId + "'信息添加成功。");
			}
			else
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"吊箱'" + info.ropewayCarId + "'信息添加失败。");				
			}
		}
		
		public function UpdateBaseInfo(baseInfo:RopewayBaseinfoVO):void
		{
			var token:AsyncToken = send("RopeDete_RopeCarriageRela_Update",onUpdateBaseInfo,baseInfo.toString());
			token.info = baseInfo;
		}
		
		private function onUpdateBaseInfo(event:ResultEvent):void
		{
			var info:RopewayBaseinfoVO = event.token.info;
			if(event.result)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"吊箱'" + info.ropewayCarId + "'信息更新成功。");
			}
			else
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,"吊箱'" + info.ropewayCarId + "'信息更新失败。");				
			}
		}
		
		public function DelBaseInfo(baseInfo:RopewayBaseinfoVO):void
		{
			var token:AsyncToken = send("RopeDete_RopeCarriageRela_Delete",onDelBaseInfo,baseInfo.toString());
			token.info = baseInfo;
		}
		
		private function onDelBaseInfo(event:ResultEvent):void
		{
			var info:RopewayBaseinfoVO = event.token.info;
			if(event.result)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"吊箱'" + info.ropewayCarId + "'信息删除成功。");
			}
			else
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,"吊箱'" + info.ropewayCarId + "'信息删除失败。");				
			}
		}
	}
}