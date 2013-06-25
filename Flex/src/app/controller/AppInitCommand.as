package app.controller
{
	import app.model.RopewayProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class AppInitCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var ropewayProxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			ropewayProxy.InitRopewayDict();
		}
	}
}