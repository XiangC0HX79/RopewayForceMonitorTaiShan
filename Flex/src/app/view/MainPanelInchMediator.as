package app.view
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	
	import app.ApplicationFacade;
	import app.view.components.MainPanelEngineTemp;
	import app.view.components.MainPanelInch;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainPanelInchMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainPanelInchMediator";
		
		public function MainPanelInchMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, new MainPanelInch);
			
			mainPanelInch.addEventListener(MainPanelInch.REALTIME_DETECTION,onMenu);
			mainPanelInch.addEventListener(MainPanelInch.ANALYSIS,onMenu);
			mainPanelInch.addEventListener(MainPanelInch.MANAGE,onMenu);
		}
		
		protected function get mainPanelInch():MainPanelInch
		{
			return viewComponent as MainPanelInch;
		}
		
		private function onMenu(event:Event):void
		{
			mainPanelInch.btnSelected = event.type;
			
			switch(event.type)
			{
				case MainPanelInch.REALTIME_DETECTION:
					sendNotification(ApplicationFacade.NOTIFY_MENU_INCH_REALTIME);
					break;
				
				case MainPanelInch.ANALYSIS:
					sendNotification(ApplicationFacade.NOTIFY_MENU_INCH_ANALYSIS);
					break;
				
				case MainPanelInch.MANAGE:
					sendNotification(ApplicationFacade.NOTIFY_MENU_INCH_MANAGER);
					break;
			}
		}
				
		private function changeContent(v:IVisualElement):void
		{
			mainPanelInch.mainContent.removeAllElements();
			mainPanelInch.mainContent.addElement(v);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_INCH_PANEL_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_INCH_PANEL_CHANGE:
					changeContent(notification.getBody() as IVisualElement);
					break;
			}
		}		
	}
}