package app.view
{	
	import mx.core.IVisualElement;
	
	import app.ApplicationFacade;
	
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
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				ApplicationFacade.NOTIFY_MENU_MAIN_OVERVIEW,
				ApplicationFacade.NOTIFY_MENU_MAIN_FORCE,
				ApplicationFacade.NOTIFY_MENU_MAIN_ENGINE_TEMP
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
				case ApplicationFacade.NOTIFY_MENU_MAIN_OVERVIEW:
					changeContent(MainPanelOverviewMediator.NAME);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_MAIN_FORCE:
					changeContent(MainPanelForceMediator.NAME);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_MAIN_ENGINE_TEMP:
					changeContent(MainPanelEngineTempMediator.NAME);
					break;
			}
		}		
	}
}