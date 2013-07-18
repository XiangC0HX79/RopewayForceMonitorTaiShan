package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayBaseinfoHisProxy;
	import app.model.RopewayBaseinfoProxy;
	import app.model.RopewayForceProxy;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayBaseinfoVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.ContentAnalysis;
	import app.view.components.ContentManage;
	import app.view.components.PanelAnalysisForce;
	
	import com.adobe.utils.StringUtil;
	
	import custom.itemRenderer.ItemRendererTodayOverview;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.RadioButton;
	import spark.components.RadioButtonGroup;
	import spark.events.GridSelectionEvent;
	
	public class ContentManageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentManageMediator";
		
		private var _ropewayBaseinfoProxy:RopewayBaseinfoProxy;
		private var _ropewayBaseinfoHisProxy:RopewayBaseinfoHisProxy;
		
		public function ContentManageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			contentManage.addEventListener(ContentManage.ROPEWAY_CHANGE,onRopewayChange);
			contentManage.addEventListener(ContentManage.ROPEWAY_RELA_CHANGE,onRopewayRelaChange);
			
			contentManage.addEventListener(ContentManage.BASEINFO_NEW,onBaseInfoNew);
			contentManage.addEventListener(ContentManage.BASEINFO_EDIT,onBaseInfoEdit);
			contentManage.addEventListener(ContentManage.BASEINFO_DEL,onBaseInfoDel);
			
			_ropewayBaseinfoProxy = facade.retrieveProxy(RopewayBaseinfoProxy.NAME) as RopewayBaseinfoProxy;
			contentManage.colBaseInfo = _ropewayBaseinfoProxy.colBaseinfo;
			
			_ropewayBaseinfoHisProxy = facade.retrieveProxy(RopewayBaseinfoHisProxy.NAME) as RopewayBaseinfoHisProxy;
			contentManage.colBaseInfoHis = _ropewayBaseinfoHisProxy.colBaseinfoHis;
		}
		
		protected function get contentManage():ContentManage
		{
			return viewComponent as ContentManage;
		}
		
		private function onRopewayChange(event:Event):void
		{
			_ropewayBaseinfoProxy.GetBaseInfo(contentManage.listRopeway.selectedItem);
		}
		
		private function onRopewayRelaChange(event:Event):void
		{
			var info:RopewayBaseinfoVO = contentManage.gridRela.selectedItem as RopewayBaseinfoVO;
			if(info)
			{
				_ropewayBaseinfoHisProxy.GetHistory(info);
			}
		}
		
		private function onBaseInfoNew(event:Event):void
		{
			var ropewayCarId:String = StringUtil.trim(contentManage.textCarId.text);
			if(ropewayCarId == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入吊箱编号！");
				return;
			}
			
			var ropewayId:String = StringUtil.trim(contentManage.textId.text);
			if(ropewayId == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入抱索器编号！");
				return;
			}
			
			var ropewayRFID:String = StringUtil.trim(contentManage.textRfId.text);
			if(ropewayRFID == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入RFID编号！");
				return;
			}
			
			for each(var r:RopewayBaseinfoVO in contentManage.colBaseInfo)
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
			info.fromRopeWay = contentManage.listRopeway.selectedItem;
			
			_ropewayBaseinfoProxy.NewBaseInfo(info);
		}
		
		private function onBaseInfoEdit(event:Event):void
		{
			event.stopPropagation();
			
			var info:RopewayBaseinfoVO = contentManage.gridRela.selectedItem as RopewayBaseinfoVO;
			if(info)
			{
				info.ropewayCarId = StringUtil.trim(contentManage.textCarId.text);
				info.ropewayId = StringUtil.trim(contentManage.textId.text);
				info.ropewayRFID = StringUtil.trim(contentManage.textRfId.text);
				
				_ropewayBaseinfoProxy.UpdateBaseInfo(info);
			}
			else
			{				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请先选择吊箱！");
			}
		}
		
		private function onBaseInfoDel(event:Event):void
		{
			var info:RopewayBaseinfoVO = contentManage.gridRela.selectedItem as RopewayBaseinfoVO;
			if(info)
			{
				_ropewayBaseinfoProxy.DelBaseInfo(info);
			}
			else
			{				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请先选择吊箱！");
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
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:
					_ropewayBaseinfoProxy.GetBaseInfo("桃花源索道");					
					break;
			}
		}
	}
}