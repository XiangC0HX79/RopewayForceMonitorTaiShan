package app.view
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	
	import app.ApplicationFacade;
	import app.model.vo.ConfigVO;
	import app.view.components.MainPanelEngineTemp;
	import app.view.components.MainPanelForce;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainPanelForceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainPanelForceMediator";
		
		public function MainPanelForceMediator()
		{
			super(NAME, new MainPanelForce);
						
			mainPanelForce.addEventListener(MainPanelForce.REALTIME_DETECTION,onMenu);
			mainPanelForce.addEventListener(MainPanelForce.TODAY_OVERVIEW,onMenu);
			mainPanelForce.addEventListener(MainPanelForce.ANALYSIS,onMenu);
			mainPanelForce.addEventListener(MainPanelForce.MANAGE,onMenu);
		}
		
		protected function get mainPanelForce():MainPanelForce
		{
			return viewComponent as MainPanelForce;
		}
				
		private function onMenu(event:Event):void
		{
			mainPanelForce.btnSelected = event.type;
			
			switch(event.type)
			{
				case MainPanelForce.REALTIME_DETECTION:
					var mediatorName:String = ContentForceRealtimeDetectionMediator.NAME;
					sendNotification(ApplicationFacade.NOTIFY_MENU_REALTIME_DETECTION);
					break;
				
				case MainPanelForce.TODAY_OVERVIEW:
					mediatorName = ContentForceTodayOverviewMediator.NAME;
					sendNotification(ApplicationFacade.NOTIFY_MENU_TODAY_OVERVIEW);
					break;
				
				case MainPanelForce.ANALYSIS:
					mediatorName = ContentForceAnalysisMediator.NAME;
					sendNotification(ApplicationFacade.NOTIFY_MENU_ANALYSIS);
					break;
				
				case MainPanelForce.MANAGE:
					mediatorName = ContentForceManageMediator.NAME;
					sendNotification(ApplicationFacade.NOTIFY_MENU_MANAGE);
					break;
			}
			
			mainPanelForce.mainContent.removeAllElements();
			
			if(mediatorName)
			{
				var mediator:IMediator = facade.retrieveMediator(mediatorName);
				mainPanelForce.mainContent.addElement(mediator.getViewComponent() as IVisualElement);		
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
					onMenu(new Event(MainPanelForce.REALTIME_DETECTION));
					break;
			}
		}		
	}
}