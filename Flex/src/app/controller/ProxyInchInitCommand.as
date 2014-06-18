package app.controller
{
	import app.ApplicationFacade;
	import app.model.InchProxy;
	import app.view.ContentInchRealtimeMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ProxyInchInitCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MENU_MAIN_INCH:
					break;
			}
			
			var inchHistoryProxy:InchProxy = facade.retrieveProxy(InchProxy.NAME) as InchProxy;
			inchHistoryProxy.Init();
		}
	}
}