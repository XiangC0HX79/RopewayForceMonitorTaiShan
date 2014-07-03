package app.controller
{
	import app.ApplicationFacade;
	import app.model.AppParamProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ActionUpdateRopewayCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
			sendNotification(ApplicationFacade.ACTION_UPDATE_ROPEWAY,appParamProxy.getCurrentRopeway());
		}		
	}
}