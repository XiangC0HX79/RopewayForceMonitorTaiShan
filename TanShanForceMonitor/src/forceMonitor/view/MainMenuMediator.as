package forceMonitor.view
{
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.view.components.MainMenu;
	
	import flash.events.Event;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MainMenuMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainMenuMediator";
		
		public function MainMenuMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			mainMenu.addEventListener(MainMenu.REALTIME_DETECTION,onRealtimeDetection);
			mainMenu.addEventListener(MainMenu.TODAY_OVERVIEW,onTodayOverview);
			mainMenu.addEventListener(MainMenu.ANALYSIS,onAnalysis);
			mainMenu.addEventListener(MainMenu.MANAGE,onManage);
		}
		
		protected function get mainMenu():MainMenu
		{
			return viewComponent as MainMenu;
		}
		
		private function onRealtimeDetection(event:Event):void
		{
			sendNotification(ForceMonitorFacade.NOTIFY_MENU_REALTIME_DETECTION);
		}
		
		private function onTodayOverview(event:Event):void
		{
			sendNotification(ForceMonitorFacade.NOTIFY_MENU_TODAY_OVERVIEW);
		}
		
		private function onAnalysis(event:Event):void
		{
			sendNotification(ForceMonitorFacade.NOTIFY_MENU_ANALYSIS);
		}
		
		private function onManage(event:Event):void
		{
			sendNotification(ForceMonitorFacade.NOTIFY_MENU_MANAGE);
		}
	}
}