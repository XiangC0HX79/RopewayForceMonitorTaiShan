package app.controller
{
	import app.model.ForceProxy;
	import app.model.vo.ForceVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifySocketForceCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var forceProxy:ForceProxy = facade.retrieveProxy(ForceProxy.NAME) as ForceProxy;
			forceProxy.Update(notification.getBody() as ForceVO);
		}
		
	}
}