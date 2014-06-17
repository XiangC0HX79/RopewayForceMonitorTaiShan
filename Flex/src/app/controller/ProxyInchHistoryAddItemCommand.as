package app.controller
{
	import app.ApplicationFacade;
	import app.model.InchHistoryProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ProxyInchHistoryAddItemCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{			
			switch(notification.getName())
			{				
				case ApplicationFacade.NOTIFY_SOCKET_INCH:	
					var inchHistoryProxy:InchHistoryProxy =  facade.retrieveProxy(InchHistoryProxy.NAME) as InchHistoryProxy;	
					inchHistoryProxy.AddInch(notification.getBody()[0],notification.getBody()[1]);
				break;
			}
		}
	}
}