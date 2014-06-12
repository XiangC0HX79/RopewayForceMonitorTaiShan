package app.view
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	
	import app.ApplicationFacade;
	import app.view.components.MainPanelEngineTemp;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainPanelEngineTempMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainPanelEngineTempMediator";
		
		public function MainPanelEngineTempMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, new MainPanelEngineTemp);
			
			mainPanelEngineTemp.addEventListener(MainPanelEngineTemp.REALTIME_DETECTION,onMenu);
			mainPanelEngineTemp.addEventListener(MainPanelEngineTemp.ANALYSIS,onMenu);
			mainPanelEngineTemp.addEventListener(MainPanelEngineTemp.MANAGE,onMenu);
		}
		
		protected function get mainPanelEngineTemp():MainPanelEngineTemp
		{
			return viewComponent as MainPanelEngineTemp;
		}
		
		private function onMenu(event:Event):void
		{
			switch(event.type)
			{
				case MainPanelEngineTemp.REALTIME_DETECTION:
					var mediatorName:String = ContentEngineTempRealtimeDetectionMediator.NAME;
					sendNotification(ApplicationFacade.NOTIFY_MENU_ENGINE_TEMP_REALTIME_DETECTION);
					break;
			}
			
			mainPanelEngineTemp.mainContent.removeAllElements();
			
			if(mediatorName)
			{
				var mediator:IMediator = facade.retrieveMediator(mediatorName);
				mainPanelEngineTemp.mainContent.addElement(mediator.getViewComponent() as IVisualElement);		
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					onMenu(new Event(MainPanelEngineTemp.REALTIME_DETECTION));
					break;
			}
		}		
	}
}