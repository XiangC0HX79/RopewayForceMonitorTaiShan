package app.controller
{
	import app.ApplicationFacade;
	import app.model.InchHistoryProxy;
	import app.view.ContentInchRealtimeMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ProxyInchHistoryInitCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MENU_MAIN_INCH:
					break;
			}
			
			var inchHistoryProxy:InchHistoryProxy = facade.retrieveProxy(InchHistoryProxy.NAME) as InchHistoryProxy;
			inchHistoryProxy.Init();
		}
	}
}