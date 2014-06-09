package app.view
{	
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.model.MaintainTypeProxy;
	import app.model.StandProxy;
	import app.model.WheelManageProxy;
	import app.model.WheelProxy;
	import app.model.vo.ConfigVO;
	import app.view.components.LoadingBar;
	
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
				
				ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE,
				ApplicationFacade.NOTIFY_INIT_WHEEL_COMPLETE,
				ApplicationFacade.NOTIFY_INIT_MAINTAINTYPE_COMPLETE,		
				
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				ApplicationFacade.NOTIFY_INIT_STATION_CHANGE
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
					loadingBar.loadingInfo = "初始化：加载支架信息...";			
					
					var config:ConfigVO = notification.getBody() as ConfigVO;
					
					var wheelManageProxy:WheelManageProxy = facade.retrieveProxy(WheelManageProxy.NAME) as WheelManageProxy;
					wheelManageProxy.InitAllWheel(FlexGlobals.topLevelApplication.Station);
					/*var standProxy:StandProxy = facade.retrieveProxy(StandProxy.NAME) as StandProxy;
					standProxy.InitStandData(s);*/
					
					break;
				case ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE:	
					loadingBar.loadingInfo = "初始化：加载支架维护信息...";
					var wheelProxy:WheelProxy = facade.retrieveProxy(WheelProxy.NAME) as WheelProxy;
					wheelProxy.InitWheelHistory(FlexGlobals.topLevelApplication.Station);	
					break;
				
				case ApplicationFacade.NOTIFY_INIT_WHEEL_COMPLETE:	
					loadingBar.loadingInfo = "初始化：滚轮信息加载完成...";		
					
					var maintainTypeProxy:MaintainTypeProxy = facade.retrieveProxy(MaintainTypeProxy.NAME) as MaintainTypeProxy;
					maintainTypeProxy.InitMaintainType();
					break;
				
				case ApplicationFacade.NOTIFY_INIT_MAINTAINTYPE_COMPLETE:
					loadingBar.loadingInfo = "初始化：维护信息加载完成...";		
					sendNotification(ApplicationFacade.NOTIFY_INIT_APP_COMPLETE);
					break;
				
				case ApplicationFacade.NOTIFY_INIT_STATION_CHANGE:	
					loadingBar.visible = true;
					loadingBar.loadingInfo = "初始化：加载支架信息...";
					wheelManageProxy = facade.retrieveProxy(WheelManageProxy.NAME) as WheelManageProxy;
					wheelManageProxy.InitAllWheel(FlexGlobals.topLevelApplication.Station);
					break;
				
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:			
					loadingBar.visible = false;
					break;
			}
		}
	}
}