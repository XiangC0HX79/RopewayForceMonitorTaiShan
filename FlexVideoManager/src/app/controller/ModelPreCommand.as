package app.controller
{	
	import app.model.AreaProxy;
	import app.model.ParamProxy;
	import app.model.VideoProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import spark.components.Application;
	
	public class ModelPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{			
			facade.registerProxy(new ParamProxy);
			
			facade.registerProxy(new AreaProxy);
			
			facade.registerProxy(new VideoProxy);
			
			var application:Application = note.getBody() as Application;
			var paramProxy:ParamProxy = facade.retrieveProxy(ParamProxy.NAME) as ParamProxy;
			paramProxy.param.edited = true;//(Number(application.parameters.edit) == 1);
		}
	}
}