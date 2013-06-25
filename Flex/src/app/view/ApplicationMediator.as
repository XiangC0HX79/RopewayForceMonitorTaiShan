package app.view
{	
	import app.ApplicationFacade;
	
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
			return [,				
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				
				ApplicationFacade.NOTIFY_MENU_REALTIME_DETECTION,
				ApplicationFacade.NOTIFY_MENU_TODAY_OVERVIEW
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					changeContent(ContentRealtimeDetectionMediator.NAME);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_REALTIME_DETECTION:
					changeContent(ContentRealtimeDetectionMediator.NAME);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_TODAY_OVERVIEW:
					changeContent(ContentTodayOverviewMediator.NAME);
					break;
			}
		}		
	}
}