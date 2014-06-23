package app.controller
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.view.ContentInchAnalysisMediator;
	import app.view.ContentInchManageMediator;
	import app.view.ContentInchRealtimeMediator;
	
	import org.puremvc.as3.multicore.interfaces.IAsyncCommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
	
	public class ActionInchPanelChangeCommand extends AsyncCommand implements IAsyncCommand
	{
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MENU_MAIN_INCH:
				case ApplicationFacade.NOTIFY_MENU_INCH_REALTIME:
					var ui:UIComponent = facade.retrieveMediator(ContentInchRealtimeMediator.NAME).getViewComponent() as UIComponent;
					ui.addEventListener(FlexEvent.ADD,onUiAdd);
					
					sendNotification(ApplicationFacade.ACTION_INCH_PANEL_CHANGE,ui);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_INCH_ANALYSIS:
					sendNotification(ApplicationFacade.ACTION_INCH_PANEL_CHANGE,facade.retrieveMediator(ContentInchAnalysisMediator.NAME).getViewComponent());
					break;
				
				case ApplicationFacade.NOTIFY_MENU_INCH_MANAGER:
					sendNotification(ApplicationFacade.ACTION_INCH_PANEL_CHANGE,facade.retrieveMediator(ContentInchManageMediator.NAME).getViewComponent());
					break;
			}
		}
		
		private function onUiAdd(event:FlexEvent):void
		{
			(event.currentTarget as UIComponent).removeEventListener(FlexEvent.ADD,onUiAdd);
			
			commandComplete(); 
		}
	}
}