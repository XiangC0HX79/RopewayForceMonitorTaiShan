package app.controller
{
	import app.ApplicationFacade;
	import app.model.InchProxy;
	import app.model.dict.RopewayDict;
	import app.model.vo.InchVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ProxyInchUpdateCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{				
				case ApplicationFacade.NOTIFY_SOCKET_INCH:					
					var inchProxy:InchProxy = facade.retrieveProxy(InchProxy.NAME) as InchProxy;	
					inchProxy.Update(notification.getBody()[0],notification.getBody()[1]);
					break;
			}
		}
	}
}