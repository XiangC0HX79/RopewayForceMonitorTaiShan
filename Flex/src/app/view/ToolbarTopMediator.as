package app.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.vo.AppParamVO;
	import app.view.components.ToolbarTop;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ToolbarTopMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ToolbarTopMediator";
				
		public function ToolbarTopMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);			
		}
		
		protected function get toolbarTop():ToolbarTop
		{
			return viewComponent as ToolbarTop;
		}
		
		override public function onRegister():void
		{			
			toolbarTop.addEventListener(ToolbarTop.STATION,onStation);
			
			toolbarTop.addEventListener(ToolbarTop.OVERVIEW,onMenuOverview);
			toolbarTop.addEventListener(ToolbarTop.FORCE,onMenuForce);
			toolbarTop.addEventListener(ToolbarTop.ENGINE,onMenuEngine);
			toolbarTop.addEventListener(ToolbarTop.INCH,onMenuInch);
			toolbarTop.addEventListener(ToolbarTop.WIND,onMenuWind);
			
			toolbarTop.addEventListener(ToolbarTop.REINIT,onMenuInit);
		}
		
		private function onStation(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_CHANGE);
		}
		
		private function onMenuOverview(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_MAIN_OVERVIEW);				
		}
		
		private function onMenuForce(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_MAIN_FORCE);				
		}
		
		private function onMenuEngine(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_MAIN_ENGINE);				
		}
		
		private function onMenuInch(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MENU_MAIN_INCH);				
		}
		
		private function onMenuWind(event:Event):void
		{			
			sendNotification(ApplicationFacade.NOTIFY_MENU_MAIN_WIND);		
		}
		
		private function onMenuInit(event:Event):void
		{			
			sendNotification(ApplicationFacade.NOTIFY_INIT_APP);	
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_ROPEWAY_LIST,
				ApplicationFacade.ACTION_UPDATE_APP_PARAM
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_ROPEWAY_LIST:
					toolbarTop.colRopeway = notification.getBody() as ArrayCollection;					
					break;
				
				case ApplicationFacade.ACTION_UPDATE_APP_PARAM:
					toolbarTop.appParam = AppParamVO(notification.getBody());
					break;
			}
		}
	}
}