package app.controller
{
	import app.model.SocketForceProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifySocketForceUploadCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var socketForcePx:SocketForceProxy = facade.retrieveProxy(SocketForceProxy.NAME) as SocketForceProxy;
			socketForcePx.unloadAndStop();
		}
		
	}
}