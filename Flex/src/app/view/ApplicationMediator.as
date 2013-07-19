package app.view
{	
	import app.ApplicationFacade;
	import app.model.vo.ConfigVO;
	
	import flash.events.Event;
	import flash.utils.Timer;
	
	import mx.core.IVisualElement;
	import mx.events.ResizeEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
		
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		private var _config:ConfigVO;
		
		public function ApplicationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get application():RopewayForceMonitor
		{
			return viewComponent as RopewayForceMonitor;
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
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,
				
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				
				ApplicationFacade.NOTIFY_MENU_REALTIME_DETECTION,
				
				ApplicationFacade.NOTIFY_MENU_TODAY_OVERVIEW,
				
				ApplicationFacade.NOTIFY_MENU_ANALYSIS,
				
				ApplicationFacade.NOTIFY_MENU_MANAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					_config = notification.getBody() as ConfigVO;
					
					changeContent(ContentRealtimeDetectionMediator.NAME);
					break;
				
				//case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
				case ApplicationFacade.NOTIFY_MENU_REALTIME_DETECTION:
					changeContent(ContentRealtimeDetectionMediator.NAME);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_TODAY_OVERVIEW:
					changeContent(ContentTodayOverviewMediator.NAME);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_ANALYSIS:
					changeContent(ContentAnalysisMediator.NAME);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_MANAGE:
					changeContent(ContentManageMediator.NAME);
					break;
			}
		}		
	}
}