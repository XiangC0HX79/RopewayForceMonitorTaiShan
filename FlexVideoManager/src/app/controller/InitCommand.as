package app.controller
{
	import app.model.AreaProxy;
	import app.model.ParamProxy;
	import app.model.VideoProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import spark.components.Application;
		
	public class InitCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var application:Application = note.getBody() as Application;
			
			var unitId:Number = Number(application.parameters.unitId);
			if(!unitId)
				unitId = 0;
			
			var areaProxy:AreaProxy = facade.retrieveProxy(AreaProxy.NAME) as AreaProxy;
			areaProxy.initData(unitId);
		}
	}
}