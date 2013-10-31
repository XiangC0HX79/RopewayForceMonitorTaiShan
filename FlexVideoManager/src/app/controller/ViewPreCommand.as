package app.controller
{		
	import app.view.ImageGroupMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import spark.components.Application;
	
	public class ViewPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var application:FlexVideoManager = note.getBody() as FlexVideoManager;
			
			facade.registerMediator(new ImageGroupMediator(application.imageGroup));
		}
	}
}