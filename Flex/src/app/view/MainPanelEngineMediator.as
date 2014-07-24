package app.view
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.view.components.MainPanelEngine;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MainPanelEngineMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainPanelEngineMediator";
		
		public function MainPanelEngineMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, new MainPanelEngine);
		}
		
		protected function get mainPanelEngineTemp():MainPanelEngine
		{
			return viewComponent as MainPanelEngine;
		}
		
		override public function onRegister():void
		{
			mainPanelEngineTemp.addEventListener(FlexEvent.REMOVE,onUiRemove);
			
			mainPanelEngineTemp.addEventListener(MainPanelEngine.REALTIME,onMenuRealtime);
			mainPanelEngineTemp.addEventListener(MainPanelEngine.ANALYSIS,onMenuAnalysis);
			mainPanelEngineTemp.addEventListener(MainPanelEngine.MANAGE,onMenuManager);
		}
		
		private function onUiRemove(event:Event):void
		{
			mainPanelEngineTemp.mainContent.removeAllElements();			
		}
		
		private function onMenuRealtime(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_ENGINE_REALTIME);
		}
		
		private function onMenuAnalysis(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_ENGINE_ANALYSIS);
		}
		
		private function onMenuManager(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_ENGINE_MANAGER);
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