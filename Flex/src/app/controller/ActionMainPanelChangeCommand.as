package app.controller
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.view.MainPanelEngineMediator;
	import app.view.MainPanelForceSWFMediator;
	import app.view.MainPanelInchMediator;
	import app.view.MainPanelOverviewMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ActionMainPanelChangeCommand extends AsyncCommand
	{
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MENU_MAIN_OVERVIEW:
					var ui:UIComponent = facade.retrieveMediator(MainPanelOverviewMediator.NAME).getViewComponent() as UIComponent;
					ui.addEventListener(FlexEvent.ADD,onUiAdd);
					sendNotification(ApplicationFacade.ACTION_MAIN_PANEL_CHANGE,ui);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_MAIN_INCH:
					ui = facade.retrieveMediator(MainPanelInchMediator.NAME).getViewComponent() as UIComponent;
					ui.addEventListener(FlexEvent.ADD,onUiAdd);
					sendNotification(ApplicationFacade.ACTION_MAIN_PANEL_CHANGE,ui);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_MAIN_FORCE:
					sendNotification(ApplicationFacade.ACTION_MAIN_PANEL_CHANGE,facade.retrieveMediator(MainPanelForceSWFMediator.NAME).getViewComponent());
					commandComplete();
					break;
				
				case ApplicationFacade.NOTIFY_MENU_MAIN_ENGINE_TEMP:
					ui = facade.retrieveMediator(MainPanelEngineMediator.NAME).getViewComponent() as UIComponent;
					ui.addEventListener(FlexEvent.ADD,onUiAdd);
					sendNotification(ApplicationFacade.ACTION_MAIN_PANEL_CHANGE,ui);
					break;
				
				default:
					ui = facade.retrieveMediator(MainPanelOverviewMediator.NAME).getViewComponent() as UIComponent;
					ui.addEventListener(FlexEvent.ADD,onUiAdd);
					sendNotification(ApplicationFacade.ACTION_MAIN_PANEL_CHANGE,ui);
			}
		}
		
		private function onUiAdd(event:FlexEvent):void
		{
			(event.currentTarget as UIComponent).removeEventListener(FlexEvent.ADD,onUiAdd);
			
			commandComplete();
		}
	}
}