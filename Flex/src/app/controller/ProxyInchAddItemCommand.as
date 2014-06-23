package app.controller
{
	import app.ApplicationFacade;
	import app.model.InchProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ProxyInchAddItemCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{			
			switch(notification.getName())
			{				
				case ApplicationFacade.NOTIFY_SOCKET_INCH:	
					var inchProxy:InchProxy =  facade.retrieveProxy(InchProxy.NAME) as InchProxy;	
					inchProxy.AddInch(notification.getBody()[0],notification.getBody()[1]);
				break;
			}
		}
	}
}