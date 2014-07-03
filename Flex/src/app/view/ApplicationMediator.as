package app.view
{	
	import mx.core.IVisualElement;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.model.InchProxy;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
		
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
				
		public function ApplicationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get application():TanShanInfoMonitor
		{
			return viewComponent as TanShanInfoMonitor;
		}
		
		private function changeContent(v:UIComponent):void
		{			
			application.mainContent.removeAllElements();
			application.mainContent.addElement(v);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_MAIN_PANEL_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_MAIN_PANEL_CHANGE:
					changeContent(UIComponent(notification.getBody()));
					break;
			}
		}		
	}
}