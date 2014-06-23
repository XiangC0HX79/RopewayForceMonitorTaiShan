package app.view
{	
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import app.ApplicationFacade;
	import app.model.vo.AppConfigVO;
	import app.view.components.LoadingBar;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.loadup.model.LoadupMonitorProxy;
	
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
				LoadupMonitorProxy.LOADING_COMPLETE,
				
				ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW,
				ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case LoadupMonitorProxy.LOADING_COMPLETE:
				case ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE:					
					loadingBar.visible = false;
					break;
				
				case ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW:
					loadingBar.loadingInfo = notification.getBody() as String;
					loadingBar.visible = true;
					break;
			}
		}
	}
}