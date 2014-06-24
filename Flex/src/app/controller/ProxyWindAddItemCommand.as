package app.controller
{
	import app.model.WindProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ProxyWindAddItemCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var windProxy:WindProxy = facade.retrieveProxy(WindProxy.NAME) as WindProxy;
			windProxy.AddItem(notification.getBody()[0],notification.getBody()[1]);
		}
		
	}
}