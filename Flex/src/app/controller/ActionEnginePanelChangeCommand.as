package app.controller
{
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.view.ContentEngineAnalysisMediator;
	import app.view.ContentEngineManageMediator;
	import app.view.ContentEngineRealtimeMediator;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
	
	public class ActionEnginePanelChangeCommand extends AsyncCommand
	{		
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MENU_MAIN_ENGINE_TEMP:
				case ApplicationFacade.NOTIFY_MENU_ENGINE_REALTIME:
					var ui:UIComponent = facade.retrieveMediator(ContentEngineRealtimeMediator.NAME).getViewComponent() as UIComponent;
					ui.addEventListener(FlexEvent.ADD,onUiAdd);
					sendNotification(ApplicationFacade.ACTION_ENGINE_PANEL_CHANGE,ui);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_ENGINE_ANALYSIS:
					sendNotification(ApplicationFacade.ACTION_ENGINE_PANEL_CHANGE,facade.retrieveMediator(ContentEngineAnalysisMediator.NAME).getViewComponent());
					break;
				
				case ApplicationFacade.NOTIFY_MENU_ENGINE_MANAGER:
					sendNotification(ApplicationFacade.ACTION_ENGINE_PANEL_CHANGE,facade.retrieveMediator(ContentEngineManageMediator.NAME).getViewComponent());
					break;
			}
		}		
		
		private function onUiAdd(event:FlexEvent):void
		{
			(event.currentTarget as  UIComponent).removeEventListener(FlexEvent.ADD,onUiAdd);
			
			commandComplete();
		}
	}
}