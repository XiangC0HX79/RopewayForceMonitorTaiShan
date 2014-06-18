package app.controller
{
	import app.ApplicationFacade;
	import app.view.ContentEngineTempRealtimeDetectionMediator;
	import app.view.ContentInchAnalysisMediator;
	import app.view.ContentInchManageMediator;
	import app.view.ContentInchRealtimeMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ActionEnginePanelChangeCommand extends SimpleCommand implements ICommand
	{		
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MENU_MAIN_ENGINE_TEMP:
				case ApplicationFacade.NOTIFY_MENU_ENGINE_REALTIME:
					sendNotification(ApplicationFacade.ACTION_ENGINE_PANEL_CHANGE,facade.retrieveMediator(ContentEngineTempRealtimeDetectionMediator.NAME).getViewComponent());
					break;
				
				case ApplicationFacade.NOTIFY_MENU_ENGINE_ANALYSIS:
					//sendNotification(ApplicationFacade.ACTION_ENGINE_PANEL_CHANGE,facade.retrieveMediator(ContentInchAnalysisMediator.NAME).getViewComponent());
					break;
				
				case ApplicationFacade.NOTIFY_MENU_ENGINE_MANAGER:
					//sendNotification(ApplicationFacade.ACTION_ENGINE_PANEL_CHANGE,facade.retrieveMediator(ContentInchManageMediator.NAME).getViewComponent());
					break;
			}
		}		
	}
}