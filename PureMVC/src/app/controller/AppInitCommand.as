package app.controller
{
	
	import app.model.ConfigProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import spark.components.Application;
	
	public class AppInitCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var application:Application = note.getBody() as Application;
			
			var proxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			
			/*var unit:String = application.parameters.unit;
			IFDEF::Debug
			{
				unit = "中天门";
			}*/
						
			var ds:String = application.parameters.DepIds;
			IFDEF::Debug
			{
				ds = "2,3,4";
			}
			
			proxy.InitConfig(ds);
		}
	}
}