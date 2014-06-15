package app.view
{
	import flash.events.Event;
	
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.dict.RopewayDict;
	import app.view.components.ToolbarTop;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ToolbarTopMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ToolbarTopMediator";
		
		public function ToolbarTopMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			toolbarTop.addEventListener(ToolbarTop.STATION,onStation);
			
			toolbarTop.addEventListener(ToolbarTop.OVERVIEW,onMenu);
			toolbarTop.addEventListener(ToolbarTop.FORCE,onMenu);
			toolbarTop.addEventListener(ToolbarTop.ENGINETEMP,onMenu);
			toolbarTop.addEventListener(ToolbarTop.INCH,onMenu);
		}
		
		protected function get toolbarTop():ToolbarTop
		{
			return viewComponent as ToolbarTop;
		}
		
		private function onStation(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_CHANGE,toolbarTop.selRopeway);
		}
		
		private function onMenu(event:Event):void
		{
			switch(event.type)
			{
				case ToolbarTop.OVERVIEW:
					sendNotification(ApplicationFacade.NOTIFY_MENU_MAIN_OVERVIEW);
					break;
				
				case ToolbarTop.FORCE:
					sendNotification(ApplicationFacade.NOTIFY_MENU_MAIN_FORCE);
					break;
				
				case ToolbarTop.ENGINETEMP:
					sendNotification(ApplicationFacade.NOTIFY_MENU_MAIN_ENGINE_TEMP);
					break;
				
				case ToolbarTop.INCH:
					break;
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
					toolbarTop.colRopeway = RopewayDict.list;
					
					toolbarTop.selRopeway = toolbarTop.colRopeway[0];
					
					onStation(null);
					break;
			}
		}		
	}
}