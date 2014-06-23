package app.view
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.controller.ActionEnginePanelChangeCommand;
	import app.view.components.MainPanelEngineTemp;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MainPanelEngineMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainPanelEngineMediator";
		
		public function MainPanelEngineMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, new MainPanelEngineTemp);
		}
		
		protected function get mainPanelEngineTemp():MainPanelEngineTemp
		{
			return viewComponent as MainPanelEngineTemp;
		}
		
		override public function onRegister():void
		{
			mainPanelEngineTemp.addEventListener(FlexEvent.REMOVE,onUiRemove);
			
			mainPanelEngineTemp.addEventListener(MainPanelEngineTemp.REALTIME_DETECTION,onMenu);
			mainPanelEngineTemp.addEventListener(MainPanelEngineTemp.ANALYSIS,onMenu);
			mainPanelEngineTemp.addEventListener(MainPanelEngineTemp.MANAGE,onMenu);
		}
		
		private function onUiRemove(event:Event):void
		{
			mainPanelEngineTemp.mainContent.removeAllElements();			
		}
		
		private function onMenu(event:Event):void
		{
			mainPanelEngineTemp.btnSelected = event.type;
			
			switch(event.type)
			{
				case MainPanelEngineTemp.REALTIME_DETECTION:
					sendNotification(ApplicationFacade.NOTIFY_MENU_ENGINE_REALTIME);
					break;
				
				case MainPanelEngineTemp.ANALYSIS:
					sendNotification(ApplicationFacade.NOTIFY_MENU_ENGINE_ANALYSIS);
					break;
				
				case MainPanelEngineTemp.MANAGE:
					sendNotification(ApplicationFacade.NOTIFY_MENU_ENGINE_MANAGER);
					break;
			}
		}
		
		private function changeContent(v:IVisualElement):void
		{
			mainPanelEngineTemp.mainContent.removeAllElements();
			mainPanelEngineTemp.mainContent.addElement(v);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_ENGINE_PANEL_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_ENGINE_PANEL_CHANGE:
					changeContent(notification.getBody() as IVisualElement);
					break;
			}
		}		
	}
}