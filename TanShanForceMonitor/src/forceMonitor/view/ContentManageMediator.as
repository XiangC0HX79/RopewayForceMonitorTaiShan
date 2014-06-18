package forceMonitor.view
{
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.model.ConfigProxy;
	import forceMonitor.model.RopewayBaseinfoHisProxy;
	import forceMonitor.model.RopewayBaseinfoProxy;
	import forceMonitor.model.RopewayForceProxy;
	import forceMonitor.model.RopewayProxy;
	import forceMonitor.model.vo.RopewayBaseinfoVO;
	import forceMonitor.model.vo.RopewayForceVO;
	import forceMonitor.model.vo.RopewayVO;
	import forceMonitor.view.components.ContentAnalysis;
	import forceMonitor.view.components.ContentManage;
	import forceMonitor.view.components.PanelAnalysisForce;
	
	import com.adobe.utils.StringUtil;
	
	import forceCustom.itemRenderer.ItemRendererTodayOverview;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.components.RadioButton;
	import spark.components.RadioButtonGroup;
	import spark.events.GridSelectionEvent;
	
	public class ContentManageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentManageMediator";
		
		public function ContentManageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{			
			contentManage.viewStatck.addChild(facade.retrieveMediator(PanelManagerBaseInfoMediator.NAME).getViewComponent() as DisplayObject);
			contentManage.viewStatck.addChild(facade.retrieveMediator(PanelManagerAdjustMediator.NAME).getViewComponent() as DisplayObject);		
		}
		
		protected function get contentManage():ContentManage
		{
			return viewComponent as ContentManage;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ForceMonitorFacade.NOTIFY_MAIN_MANAGER_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForceMonitorFacade.NOTIFY_MAIN_MANAGER_CHANGE:
					contentManage.viewStatck.selectedIndex = Number(notification.getBody());
					break;
			}
		}
	}
}