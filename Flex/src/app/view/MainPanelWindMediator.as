package app.view
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.view.components.MainPanelEngine;
	import app.view.components.MainPanelWind;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MainPanelWindMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainPanelWindMediator";
		
		public function MainPanelWindMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, new MainPanelWind);
		}
		
		protected function get mainPanelWind():MainPanelWind
		{
			return viewComponent as MainPanelWind;
		}
		
		override public function onRegister():void
		{
			mainPanelWind.addEventListener(FlexEvent.REMOVE,onUiRemove);
			
			mainPanelWind.addEventListener(MainPanelEngine.REALTIME,onMenuRealtime);
			mainPanelWind.addEventListener(MainPanelEngine.ANALYSIS,onMenuAnalysis);
			mainPanelWind.addEventListener(MainPanelEngine.MANAGE,onMenuManager);
		}
		
		private function onUiRemove(event:Event):void
		{
			mainPanelWind.mainContent.removeAllElements();			
		}
		
		private function onMenuRealtime(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_WIND_REALTIME);
		}
		
		private function onMenuAnalysis(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_WIND_ANALYSIS);
		}
		
		private function onMenuManager(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_WIND_MANAGER);
		}
		
		private function changeContent(v:IVisualElement):void
		{
			mainPanelWind.mainContent.removeAllElements();
			mainPanelWind.mainContent.addElement(v);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_WIND_PANEL_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_WIND_PANEL_CHANGE:
					changeContent(notification.getBody() as IVisualElement);
					break;
			}
		}		
	}
}