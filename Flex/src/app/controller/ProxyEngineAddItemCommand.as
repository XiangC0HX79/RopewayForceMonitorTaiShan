package app.controller
{
	import app.ApplicationFacade;
	import app.model.EngineProxy;
	import app.model.vo.EngineVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ProxyEngineAddItemCommand extends SimpleCommand implements ICommand
	{		
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_SOCKET_ENGINE_TEMP:
					var engineTempProxy:EngineProxy = facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;						
					engineTempProxy.AddItem(notification.getBody()[0],notification.getBody()[1],notification.getBody()[2]);
					break;
			}
		}
		
	}
}