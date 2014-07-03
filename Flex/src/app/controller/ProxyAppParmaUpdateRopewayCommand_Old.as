package app.controller
{
	import app.model.AppParamProxy;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ProxyAppParmaUpdateRopewayCommand_Old extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
			appParamProxy.updateRopeway(RopewayVO(notification.getBody()));
		}
		
	}
}