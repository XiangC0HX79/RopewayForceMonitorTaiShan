package app.controller
{
	import app.ApplicationFacade;
	import app.view.MainPanelInchMediator;
	import app.view.MainPanelOverviewMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ActionMainPanelChangeCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
				case ApplicationFacade.NOTIFY_MENU_MAIN_OVERVIEW:
					sendNotification(ApplicationFacade.ACTION_MAIN_PANEL_CHANGE,facade.retrieveMediator(MainPanelOverviewMediator.NAME).getViewComponent());
					break;
				
				case ApplicationFacade.NOTIFY_MENU_MAIN_INCH:
					sendNotification(ApplicationFacade.ACTION_MAIN_PANEL_CHANGE,facade.retrieveMediator(MainPanelInchMediator.NAME).getViewComponent());
					break;
			}
		}
	}
}