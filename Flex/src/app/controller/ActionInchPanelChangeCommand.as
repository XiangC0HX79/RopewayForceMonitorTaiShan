package app.controller
{
	import app.ApplicationFacade;
	import app.view.ContentInchAnalysisMediator;
	import app.view.ContentInchManageMediator;
	import app.view.ContentInchRealtimeMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ActionInchPanelChangeCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MENU_MAIN_INCH:
				case ApplicationFacade.NOTIFY_MENU_INCH_REALTIME:
					sendNotification(ApplicationFacade.ACTION_INCH_PANEL_CHANGE,facade.retrieveMediator(ContentInchRealtimeMediator.NAME).getViewComponent());
					break;
				
				case ApplicationFacade.NOTIFY_MENU_INCH_ANALYSIS:
					sendNotification(ApplicationFacade.ACTION_INCH_PANEL_CHANGE,facade.retrieveMediator(ContentInchAnalysisMediator.NAME).getViewComponent());
					break;
				
				case ApplicationFacade.NOTIFY_MENU_INCH_MANAGER:
					sendNotification(ApplicationFacade.ACTION_INCH_PANEL_CHANGE,facade.retrieveMediator(ContentInchManageMediator.NAME).getViewComponent());
					break;
			}
		}
	}
}