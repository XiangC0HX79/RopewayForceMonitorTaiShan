package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayBaseinfoHisProxy;
	import app.model.RopewayBaseinfoProxy;
	import app.model.vo.RopewayBaseinfoVO;
	import app.view.components.PanelManagerBaseInfo;
	
	import com.adobe.utils.StringUtil;
	
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
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
			panelManagerBaseInfo.addEventListener(PanelManagerBaseInfo.BASEINFO_DEL,onBaseInfoDel);
			panelManagerBaseInfo.addEventListener(PanelManagerBaseInfo.BASEINFO_USE,onBaseInfoUse);
			
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
				_ropewayBaseinfoHisProxy.GetHistory(info);
			}
		}
		
		private function onBaseInfoNew(event:Event):void
		{
			var ropewayCarId:String = StringUtil.trim(panelManagerBaseInfo.textCarId.text);
			if(ropewayCarId == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入吊箱编号！");
				return;
			}
			
			var ropewayId:String = StringUtil.trim(panelManagerBaseInfo.textId.text);
			if(ropewayId == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入抱索器编号！");
				return;
			}
			
			var ropewayRFID:String = StringUtil.trim(panelManagerBaseInfo.textRfId.text);
			if(ropewayRFID == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入RFID编号！");
				return;
			}
			
			for each(var r:RopewayBaseinfoVO in panelManagerBaseInfo.colBaseInfo)
			{
				if(r.ropewayCarId == ropewayCarId)
				{
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"吊箱编号已存在！");
					return;					
				}
				
				if(r.ropewayId == ropewayId)
				{
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"抱索器编号已存在！");
					return;					
				}
				
				if(r.ropewayRFID == ropewayRFID)
				{
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"RFID编号已存在！");
					return;					
				}
			}
			
			var info:RopewayBaseinfoVO = new RopewayBaseinfoVO;
			info.ropewayId = ropewayId;
			info.ropewayCarId = ropewayCarId;
			info.ropewayRFID = ropewayRFID;
			info.fromRopeWay = panelManagerBaseInfo.listRopeway.selectedItem;
			
			_ropewayBaseinfoProxy.NewBaseInfo(info);
		}
		
		private function onBaseInfoEdit(event:Event):void
		{
			var info:RopewayBaseinfoVO = panelManagerBaseInfo.gridRela.selectedItem as RopewayBaseinfoVO;
			if(info)
			{
				info.ropewayCarId = StringUtil.trim(panelManagerBaseInfo.textCarId.text);
				info.ropewayId = StringUtil.trim(panelManagerBaseInfo.textId.text);
				info.ropewayRFID = StringUtil.trim(panelManagerBaseInfo.textRfId.text);
				
				_ropewayBaseinfoProxy.UpdateBaseInfo(info);
			}
			else
			{				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请先选择吊箱！");
			}
		}
		
		private function onBaseInfoUse(event:Event):void
		{
			event.stopPropagation();
			
			var info:RopewayBaseinfoVO = panelManagerBaseInfo.gridRela.selectedItem as RopewayBaseinfoVO;
			if(info)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,["请确认是否更改吊箱的可用信息？",onBaseInfoUseConfirm,Alert.YES | Alert.NO]);
			}
			else
			{				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请先选择吊箱！");
			}
		}
		
		private function onBaseInfoUseConfirm(event:CloseEvent):void
		{
			var info:RopewayBaseinfoVO = panelManagerBaseInfo.gridRela.selectedItem as RopewayBaseinfoVO;
			if(event.detail == Alert.YES)
			{
				_ropewayBaseinfoProxy.UpdateBaseInfo(info);
			}
			else
			{
				info.isUse = !info.isUse;
			}
		}
		
		private function onBaseInfoDel(event:Event):void
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
		}
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:					
					_ropewayBaseinfoProxy.GetBaseInfo("桃花源索道");	
					break;
			}
		}
	}
}