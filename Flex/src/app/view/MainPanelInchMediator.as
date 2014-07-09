package app.view
{
	import flash.events.Event;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.view.components.MainPanelInch;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MainPanelInchMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainPanelInchMediator";
		
		public function MainPanelInchMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, new MainPanelInch);
		}
		
		protected function get mainPanelInch():MainPanelInch
		{
			return viewComponent as MainPanelInch;
		}
		
		override public function onRegister():void
		{
			mainPanelInch.addEventListener(FlexEvent.REMOVE,onUiRemove);
			
			mainPanelInch.addEventListener(MainPanelInch.REALTIME,onMenuRealtime);
			mainPanelInch.addEventListener(MainPanelInch.ANALYSIS,onMenuAnalysis);
			mainPanelInch.addEventListener(MainPanelInch.MANAGE,onMenuManager);
		}
		
		private function onUiRemove(event:Event):void
		{
			mainPanelInch.mainContent.removeAllElements();			
		}
		
		private function onMenuRealtime(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_INCH_REALTIME);
		}
		
		private function onMenuAnalysis(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_INCH_ANALYSIS);
		}
		
		private function onMenuManager(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_INCH_MANAGER);
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