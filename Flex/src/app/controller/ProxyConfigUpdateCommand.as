package app.controller
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.dict.RopewayDict;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ProxyConfigUpdateCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_ROPEWAY_CHANGE:
					break;
			}
			
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			configProxy.config.ropeway = notification.getBody() as RopewayDict;
		}
	}
}