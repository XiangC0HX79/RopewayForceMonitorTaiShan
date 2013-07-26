package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayBaseinfoProxy;
	import app.model.vo.RopewayBaseinfoVO;
	import app.view.components.TitleWindowBaseInfo;
	
	import com.adobe.utils.StringUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TitleWindowBaseInfoMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TitleWindowBaseInfoMediator";
		
		private var _ropewayBaseinfoProxy:RopewayBaseinfoProxy;
		
		public function TitleWindowBaseInfoMediator()
		{
			super(NAME, new TitleWindowBaseInfo);
			
			titleWindowBaseInfo.addEventListener(CloseEvent.CLOSE,onClose);
			
			titleWindowBaseInfo.addEventListener(TitleWindowBaseInfo.BASEINFO_NEW,onBaseInfoNew);
			titleWindowBaseInfo.addEventListener(TitleWindowBaseInfo.BASEINFO_EDIT,onBaseInfoEdit);
			
			_ropewayBaseinfoProxy = facade.retrieveProxy(RopewayBaseinfoProxy.NAME) as RopewayBaseinfoProxy;
		}
		
		protected function get titleWindowBaseInfo():TitleWindowBaseInfo
		{
			return viewComponent as TitleWindowBaseInfo;
		}
		
		private function onClose(event:Event):void
		{
			PopUpManager.removePopUp(titleWindowBaseInfo);
		}
		
		private function check():void
		{
			
		}
		
		private function onBaseInfoNew(event:Event):void
		{
			var ropewayCarId:String = StringUtil.trim(titleWindowBaseInfo.textCarId.text);
			if(ropewayCarId == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入吊箱编号！");
				return;
			}
			
			var ropewayId:String = StringUtil.trim(titleWindowBaseInfo.textId.text);
			if(ropewayId == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入抱索器编号！");
				return;
			}
			
			var ropewayRFID:String = StringUtil.trim(titleWindowBaseInfo.textRfId.text);
			if(ropewayRFID == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入RFID编号！");
				return;
			}
			
			for each(var r:RopewayBaseinfoVO in _ropewayBaseinfoProxy.colBaseinfo)
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
			
			var info:RopewayBaseinfoVO = titleWindowBaseInfo.baseInfo;	
			info.ropewayId = ropewayId;
			info.ropewayCarId = ropewayCarId;
			info.ropewayRFID = ropewayRFID;
			info.fromRopeWay = titleWindowBaseInfo.listRopeway.selectedItem;
			info.memo = StringUtil.trim(titleWindowBaseInfo.textMemo.text);
			
			_ropewayBaseinfoProxy.NewBaseInfo(info);
			
			PopUpManager.removePopUp(titleWindowBaseInfo);
		}
		
		private function onBaseInfoEdit(event:Event):void
		{
			var ropewayCarId:String = StringUtil.trim(titleWindowBaseInfo.textCarId.text);
			if(ropewayCarId == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入吊箱编号！");
				return;
			}
			
			var ropewayId:String = StringUtil.trim(titleWindowBaseInfo.textId.text);
			if(ropewayId == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入抱索器编号！");
				return;
			}
			
			var ropewayRFID:String = StringUtil.trim(titleWindowBaseInfo.textRfId.text);
			if(ropewayRFID == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入RFID编号！");
				return;
			}
			
			for each(var r:RopewayBaseinfoVO in _ropewayBaseinfoProxy.colBaseinfo)
			{
				if(r.ropewayCarId == ropewayCarId)
				{
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"吊箱编号已存在！");
					return;					
				}
				
				if(r.ropewayRFID == ropewayRFID)
				{
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"RFID编号已存在！");
					return;					
				}
			}
			
			var info:RopewayBaseinfoVO = titleWindowBaseInfo.baseInfo;			
			info.ropewayCarId = StringUtil.trim(titleWindowBaseInfo.textCarId.text);
			info.ropewayId = StringUtil.trim(titleWindowBaseInfo.textId.text);
			info.ropewayRFID = StringUtil.trim(titleWindowBaseInfo.textRfId.text);
			info.memo = StringUtil.trim(titleWindowBaseInfo.textMemo.text);
			
			_ropewayBaseinfoProxy.UpdateBaseInfo(info);
			
			PopUpManager.removePopUp(titleWindowBaseInfo);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_ROPEWAY_BASEINFO_NEW,				
				ApplicationFacade.NOTIFY_ROPEWAY_BASEINFO_EDIT
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_ROPEWAY_BASEINFO_NEW:
					titleWindowBaseInfo.currentState = "New";
					
					titleWindowBaseInfo.baseInfo = new RopewayBaseinfoVO;
					titleWindowBaseInfo.baseInfo.fromRopeWay = String(notification.getBody());
					
					PopUpManager.addPopUp(titleWindowBaseInfo,FlexGlobals.topLevelApplication as DisplayObject,true);
					PopUpManager.centerPopUp(titleWindowBaseInfo);
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_BASEINFO_EDIT:
					titleWindowBaseInfo.currentState = "Edit";
					
					titleWindowBaseInfo.baseInfo = notification.getBody() as RopewayBaseinfoVO;
					
					PopUpManager.addPopUp(titleWindowBaseInfo,FlexGlobals.topLevelApplication as DisplayObject,true);
					PopUpManager.centerPopUp(titleWindowBaseInfo);
					break;
			}
		}
	}
}