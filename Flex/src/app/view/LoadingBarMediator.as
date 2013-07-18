package app.view
{	
	import app.ApplicationFacade;
	import app.model.RopewayAlarmProxy;
	import app.model.RopewayListProxy;
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
			
			var contextMenu:ContextMenu=new ContextMenu();
			contextMenu.hideBuiltInItems(); 
			
			var contextMenuItem:ContextMenuItem= new ContextMenuItem("版本：1.0.1");			
			contextMenu.customItems.push(contextMenuItem);
			
			loadingBar.contextMenu=contextMenu;
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
										
					var ropewayProxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
					ropewayProxy.InitRopewayDict();		
					
					var ropewayListProxy:RopewayListProxy = facade.retrieveProxy(RopewayListProxy.NAME) as RopewayListProxy;
					ropewayListProxy.GetRopewayList();
					break;
				
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:	
					loadingBar.loadingInfo = "初始化：索道信息加载完成...";		
					sendNotification(ApplicationFacade.NOTIFY_INIT_APP_COMPLETE);
					break;
				
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:			
					//loadingBar.visible = false;
					break;
			}
		}
	}
}