package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
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
		
		public function ContentManageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
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
				ApplicationFacade.NOTIFY_MAIN_MANAGER_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MAIN_MANAGER_CHANGE:
					contentManage.viewStatck.selectedIndex = Number(notification.getBody());
					break;
			}
		}
	}
}