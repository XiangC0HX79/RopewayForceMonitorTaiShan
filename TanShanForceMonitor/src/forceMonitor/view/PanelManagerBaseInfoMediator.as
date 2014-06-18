package forceMonitor.view
{
	import com.adobe.utils.StringUtil;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.model.RopewayAlarmDealProxy;
	import forceMonitor.model.RopewayBaseinfoHisProxy;
	import forceMonitor.model.RopewayBaseinfoProxy;
	import forceMonitor.model.vo.RopewayBaseinfoVO;
	import forceMonitor.view.components.PanelManagerBaseInfo;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelManagerBaseInfoMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelManagerBaseInfoMediator";
		
		private var _ropewayBaseinfoProxy:RopewayBaseinfoProxy;
		private var _ropewayBaseinfoHisProxy:RopewayBaseinfoHisProxy;
		
		public function PanelManagerBaseInfoMediator()
		{
			super(NAME, new PanelManagerBaseInfo);
			
			panelManagerBaseInfo.addEventListener(PanelManagerBaseInfo.ROPEWAY_CHANGE,onRopewayChange);
			panelManagerBaseInfo.addEventListener(PanelManagerBaseInfo.ROPEWAY_RELA_CHANGE,onRopewayRelaChange);
			
			panelManagerBaseInfo.addEventListener(PanelManagerBaseInfo.BASEINFO_NEW,onBaseInfoNew);
			panelManagerBaseInfo.addEventListener(PanelManagerBaseInfo.BASEINFO_EDIT,onBaseInfoEdit);
			panelManagerBaseInfo.addEventListener(PanelManagerBaseInfo.BASEINFO_DEL,onBaseInfoUse);
			panelManagerBaseInfo.addEventListener(PanelManagerBaseInfo.BASEINFO_USE,onBaseInfoUse);
		}
		
		override public function onRegister():void
		{						
			_ropewayBaseinfoProxy = facade.retrieveProxy(RopewayBaseinfoProxy.NAME) as RopewayBaseinfoProxy;
			panelManagerBaseInfo.colBaseInfo = _ropewayBaseinfoProxy.colBaseinfo;
			
			_ropewayBaseinfoHisProxy = facade.retrieveProxy(RopewayBaseinfoHisProxy.NAME) as RopewayBaseinfoHisProxy;
			panelManagerBaseInfo.colBaseInfoHis = _ropewayBaseinfoHisProxy.colBaseinfoHis;
		}		
		
		protected function get panelManagerBaseInfo():PanelManagerBaseInfo
		{
			return viewComponent as PanelManagerBaseInfo;
		}
				
		private function onRopewayChange(event:Event):void
		{
			_ropewayBaseinfoProxy.GetBaseInfo(panelManagerBaseInfo.listRopeway.selectedItem);
		}
		
		private function onRopewayRelaChange(event:Event):void
		{
			var info:RopewayBaseinfoVO = panelManagerBaseInfo.gridRela.selectedItem as RopewayBaseinfoVO;
			if(info)
			{
				panelManagerBaseInfo.lbUse.label = info.isUse?"禁用":"启用";
				
				_ropewayBaseinfoHisProxy.GetHistory(info);
			}
		}
		
		private function onBaseInfoNew(event:Event):void
		{
			sendNotification(ForceMonitorFacade.NOTIFY_ROPEWAY_BASEINFO_NEW,panelManagerBaseInfo.listRopeway.selectedItem);
		}
		
		private function onBaseInfoEdit(event:Event):void
		{
			var info:RopewayBaseinfoVO = panelManagerBaseInfo.gridRela.selectedItem as RopewayBaseinfoVO;
			if(info)
			{
				sendNotification(ForceMonitorFacade.NOTIFY_ROPEWAY_BASEINFO_EDIT,info);
			}
			else
			{				
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"请先选择抱索器！");
			}
		}
		
		private function onBaseInfoUse(event:Event):void
		{
			event.stopPropagation();
			
			var info:RopewayBaseinfoVO = panelManagerBaseInfo.gridRela.selectedItem as RopewayBaseinfoVO;
			if(info)
			{
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,["请确认是否更改抱索器的可用信息？",onBaseInfoUseConfirm,Alert.YES | Alert.NO]);
			}
			else
			{				
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"请先选择抱索器！");
			}
		}
		
		private function onBaseInfoUseConfirm(event:CloseEvent):void
		{
			var info:RopewayBaseinfoVO = panelManagerBaseInfo.gridRela.selectedItem as RopewayBaseinfoVO;
			if(event.detail == Alert.YES)
			{
				info.isUse = !info.isUse;
				
				panelManagerBaseInfo.lbUse.label = info.isUse?"禁用":"启用";
				
				_ropewayBaseinfoProxy.UpdateBaseInfoUse(info);
			}
		}
		
		/*private function onBaseInfoDel(event:Event):void
		{			
			var info:RopewayBaseinfoVO = panelManagerBaseInfo.gridRela.selectedItem as RopewayBaseinfoVO;
			if(info)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,["请确认是否删除吊箱信息？",onBaseInfoDelConfirm,Alert.YES | Alert.NO]);
			}
			else
			{				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请先选择吊箱！");
			}
		}
		
		private function onBaseInfoDelConfirm(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				var info:RopewayBaseinfoVO = panelManagerBaseInfo.gridRela.selectedItem as RopewayBaseinfoVO;
				_ropewayBaseinfoProxy.DelBaseInfo(info);
			}
		}*/
		
		override public function listNotificationInterests():Array
		{
			return [
				ForceMonitorFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForceMonitorFacade.NOTIFY_INIT_APP_COMPLETE:					
					_ropewayBaseinfoProxy.GetBaseInfo("桃花源索道");	
					break;
			}
		}
	}
}