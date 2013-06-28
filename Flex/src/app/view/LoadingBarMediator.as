package app.view
{	
	import app.ApplicationFacade;
	import app.model.RopewayAlarmProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.view.components.LoadingBar;
	
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LoadingBarMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "LoadingBarMediator";
				
		public function LoadingBarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		private function get loadingBar():LoadingBar
		{
			return viewComponent as LoadingBar;
		}		
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW,
				ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE,
				
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,
				ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
						
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE:					
					loadingBar.visible = false;
					break;
				
				case ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW:
					loadingBar.loadingInfo = notification.getBody() as String;
					loadingBar.visible = true;
					break;
				
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					loadingBar.loadingInfo = "初始化：本地配置加载完成...";			
					
					var config:ConfigVO = notification.getBody() as ConfigVO;
					var s:String = config.station?config.station:config.stations[0];
					
					var ropewayProxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
					ropewayProxy.InitRopewayDict(s);
					
					var ropewayAlarmProxy:RopewayAlarmProxy = facade.retrieveProxy(RopewayAlarmProxy.NAME) as RopewayAlarmProxy;
					ropewayAlarmProxy.InitAlarmArr(s);
					break;
				
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:	
					loadingBar.loadingInfo = "初始化：索道信息加载完成...";		
					sendNotification(ApplicationFacade.NOTIFY_INIT_APP_COMPLETE);
					break;
				
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:			
					loadingBar.visible = false;
					break;
			}
		}
	}
}