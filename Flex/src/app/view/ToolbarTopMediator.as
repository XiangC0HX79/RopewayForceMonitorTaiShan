package app.view
{
	import flash.events.Event;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import app.ApplicationFacade;
	import app.model.AppConfigProxy;
	import app.model.AppParamProxy;
	import app.model.RopewayProxy;
	import app.model.vo.AppConfigVO;
	import app.model.vo.RopewayVO;
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
			
			toolbarTop.addEventListener(ToolbarTop.STATION,onStation);
			
			toolbarTop.addEventListener(ToolbarTop.OVERVIEW,onMenu);
			toolbarTop.addEventListener(ToolbarTop.FORCE,onMenu);
			toolbarTop.addEventListener(ToolbarTop.ENGINETEMP,onMenu);
			toolbarTop.addEventListener(ToolbarTop.INCH,onMenu);
			toolbarTop.addEventListener(ToolbarTop.WIND,onMenu);
		}
		
		protected function get toolbarTop():ToolbarTop
		{
			return viewComponent as ToolbarTop;
		}
		
		override public function onRegister():void
		{
			var ropewayProxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			toolbarTop.colRopeway = ropewayProxy.list;
			
			var appParaProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
			toolbarTop.selRopeway = appParaProxy.appParam.selRopeway;
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
					sendNotification(ApplicationFacade.NOTIFY_MENU_MAIN_INCH);
					break;
				
				case ToolbarTop.WIND:
					break;
			}
		}
	}
}