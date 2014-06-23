package forceMonitor.view
{	
	import flash.events.Event;
	import flash.utils.Timer;
	
	import mx.core.IVisualElement;
	import mx.events.ResizeEvent;
	
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.model.vo.ConfigVO;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
		
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		private var _config:ConfigVO;
		
		public function ApplicationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get application():TanShanForceMonitor
		{
			return viewComponent as TanShanForceMonitor;
		}
		
		private function changeContent(n:String):void
		{
			application.mainContent.removeAllElements();
			
			var mediator:IMediator = facade.retrieveMediator(n);
			application.mainContent.addElement(mediator.getViewComponent() as IVisualElement);			
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ForceMonitorFacade.NOTIFY_INIT_CONFIG_COMPLETE,
				
				ForceMonitorFacade.NOTIFY_INIT_APP_COMPLETE,
				
				ForceMonitorFacade.NOTIFY_MENU_REALTIME_DETECTION,
				
				ForceMonitorFacade.NOTIFY_MENU_TODAY_OVERVIEW,
				
				ForceMonitorFacade.NOTIFY_MENU_ANALYSIS,
				
				ForceMonitorFacade.NOTIFY_MENU_MANAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ForceMonitorFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					_config = notification.getBody() as ConfigVO;
					
					changeContent(ContentRealtimeDetectionMediator.NAME);
					break;
				
				//case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
				case ForceMonitorFacade.NOTIFY_MENU_REALTIME_DETECTION:
					changeContent(ContentRealtimeDetectionMediator.NAME);
					break;
				
				case ForceMonitorFacade.NOTIFY_MENU_TODAY_OVERVIEW:
					changeContent(ContentTodayOverviewMediator.NAME);
					break;
				
				case ForceMonitorFacade.NOTIFY_MENU_ANALYSIS:
					changeContent(ContentAnalysisMediator.NAME);
					break;
				
				case ForceMonitorFacade.NOTIFY_MENU_MANAGE:
					changeContent(ContentManageMediator.NAME);
					break;
			}
		}		
	}
}