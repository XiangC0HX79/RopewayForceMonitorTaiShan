package app.view
{
	import com.adobe.utils.StringUtil;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import app.ApplicationFacade;
	import app.model.CarriageProxy;
	import app.model.CarriageEditHisProxy;
	import app.model.dict.RopewayDict;
	import app.model.vo.CarriageVO;
	import app.view.components.PanelForceManagerBaseInfo;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelForceManagerBaseInfoMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelForceManagerBaseInfoMediator";
		
		private var _ropewayBaseinfoProxy:CarriageProxy;
		private var _ropewayBaseinfoHisProxy:CarriageEditHisProxy;
		
		public function PanelForceManagerBaseInfoMediator()
		{
			super(NAME, new PanelForceManagerBaseInfo);
			
			panelManagerBaseInfo.addEventListener(PanelForceManagerBaseInfo.ROPEWAY_CHANGE,onRopewayChange);
			
			panelManagerBaseInfo.addEventListener(PanelForceManagerBaseInfo.ROPEWAY_RELA_CHANGE,onRopewayRelaChange);
			
			panelManagerBaseInfo.addEventListener(PanelForceManagerBaseInfo.BASEINFO_NEW,onBaseInfoNew);
			panelManagerBaseInfo.addEventListener(PanelForceManagerBaseInfo.BASEINFO_EDIT,onBaseInfoEdit);
			panelManagerBaseInfo.addEventListener(PanelForceManagerBaseInfo.BASEINFO_DEL,onBaseInfoUse);
			panelManagerBaseInfo.addEventListener(PanelForceManagerBaseInfo.BASEINFO_USE,onBaseInfoUse);
			
			_ropewayBaseinfoProxy = facade.retrieveProxy(CarriageProxy.NAME) as CarriageProxy;
			//panelManagerBaseInfo.colBaseInfo = _ropewayBaseinfoProxy.colBaseinfo;
			
			_ropewayBaseinfoHisProxy = facade.retrieveProxy(CarriageEditHisProxy.NAME) as CarriageEditHisProxy;
			panelManagerBaseInfo.colBaseInfoHis = _ropewayBaseinfoHisProxy.colBaseinfoHis;
		}
		
		protected function get panelManagerBaseInfo():PanelForceManagerBaseInfo
		{
			return viewComponent as PanelForceManagerBaseInfo;
		}
				
		private function onRopewayChange(event:Event):void
		{
			panelManagerBaseInfo.colBaseInfo = _ropewayBaseinfoProxy.GetCarriage(panelManagerBaseInfo.listRopeway.selectedItem);
		}
		
		private function onRopewayRelaChange(event:Event):void
		{
			var info:CarriageVO = panelManagerBaseInfo.gridRela.selectedItem as CarriageVO;
			if(info)
			{
				panelManagerBaseInfo.lbUse.label = info.isUse?"禁用":"启用";
				
				_ropewayBaseinfoHisProxy.GetHistory(info);
			}
		}
		
		private function onBaseInfoNew(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_BASEINFO_NEW,panelManagerBaseInfo.listRopeway.selectedItem);
		}
		
		private function onBaseInfoEdit(event:Event):void
		{
			var info:CarriageVO = panelManagerBaseInfo.gridRela.selectedItem as CarriageVO;
			if(info)
			{
				sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_BASEINFO_EDIT,info);
			}
			else
			{				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请先选择抱索器！");
			}
		}
		
		private function onBaseInfoUse(event:Event):void
		{
			event.stopPropagation();
			
			var info:CarriageVO = panelManagerBaseInfo.gridRela.selectedItem as CarriageVO;
			if(info)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,["请确认是否更改抱索器的可用信息？",onBaseInfoUseConfirm,Alert.YES | Alert.NO]);
			}
			else
			{				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请先选择抱索器！");
			}
		}
		
		private function onBaseInfoUseConfirm(event:CloseEvent):void
		{
			var info:CarriageVO = panelManagerBaseInfo.gridRela.selectedItem as CarriageVO;
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
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				
				ApplicationFacade.NOTIFY_ROPEWAY_INFO_SET
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					panelManagerBaseInfo.colRopeway = RopewayDict.list;
					
					panelManagerBaseInfo.colBaseInfo = _ropewayBaseinfoProxy.GetCarriage(panelManagerBaseInfo.colRopeway[0]);
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_SET:
					if(notification.getBody() != "Update")
						panelManagerBaseInfo.colBaseInfo = _ropewayBaseinfoProxy.GetCarriage(panelManagerBaseInfo.listRopeway.selectedItem);					
					break;
			}
		}
	}
}