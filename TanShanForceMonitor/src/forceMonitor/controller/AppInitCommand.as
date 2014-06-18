package forceMonitor.controller
{
	import spark.components.Application;
	
	import forceMonitor.model.ConfigProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class AppInitCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var application:Application = note.getBody() as Application;
			
			var proxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			
			proxy.InitConfig(application.parameters.station,application.parameters.ropeway);
		}
	}
}