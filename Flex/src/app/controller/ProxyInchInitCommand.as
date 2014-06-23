package app.controller
{
	import app.ApplicationFacade;
	import app.model.InchProxy;
	import app.view.ContentInchRealtimeMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ProxyInchInitCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{			
			//var inchHistoryProxy:InchProxy = facade.retrieveProxy(InchProxy.NAME) as InchProxy;
			//inchHistoryProxy.Init();
		}
	}
}