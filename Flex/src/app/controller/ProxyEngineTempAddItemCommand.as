package app.controller
{
	import app.ApplicationFacade;
	import app.model.EngineTempProxy;
	import app.model.vo.EngineVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ProxyEngineTempAddItemCommand extends SimpleCommand implements ICommand
	{		
		override public function execute(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_SOCKET_ENGINE_TEMP:
					var engineTempProxy:EngineTempProxy = facade.retrieveProxy(EngineTempProxy.NAME) as EngineTempProxy;						
					engineTempProxy.AddItem(notification.getBody()[0],notification.getBody()[1],notification.getBody()[2]);
					break;
			}
		}
		
	}
}