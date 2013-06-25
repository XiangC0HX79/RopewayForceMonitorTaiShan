package app.view
{
	import app.ApplicationFacade;
	import app.view.components.MainMenu;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainMenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainMenuMediator";
		
		public function MainMenuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			mainMenu.addEventListener(MainMenu.REALTIME_DETECTION,onRealtimeDetection);
			mainMenu.addEventListener(MainMenu.TODAY_OVERVIEW,onTodayOverview);
		}
		
		protected function get mainMenu():MainMenu
		{
			return viewComponent as MainMenu;
		}
		
		private function onRealtimeDetection(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_REALTIME_DETECTION);
		}
		
		private function onTodayOverview(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_TODAY_OVERVIEW);
		}
	}
}