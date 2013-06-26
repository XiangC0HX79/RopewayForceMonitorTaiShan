package app.controller
{
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class AppInitCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var proxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			proxy.InitConfig();
		}
	}
}