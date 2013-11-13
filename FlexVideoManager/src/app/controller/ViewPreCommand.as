package app.controller
{		
	import app.view.AlertMediator;
	import app.view.FlexVideoManagerMediator;
	import app.view.ImageGroupMediator;
	import app.view.LoadingBarMediator;
	import app.view.MenuGroupMediator;
	import app.view.TipGroupMediator;
	import app.view.ToolGroupMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import spark.components.Application;
	
	public class ViewPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var application:FlexVideoManager = note.getBody() as FlexVideoManager;
						
			facade.registerMediator(new AlertMediator);
			
			facade.registerMediator(new FlexVideoManagerMediator(application));
			
			facade.registerMediator(new ImageGroupMediator(application.imageGroup));
			
			facade.registerMediator(new ToolGroupMediator(application.toolGroup));
			
			facade.registerMediator(new TipGroupMediator(application.tipGroup));
			
			facade.registerMediator(new LoadingBarMediator(application.loadingBar));
			
			facade.registerMediator(new MenuGroupMediator(application.menuGroup));
		}
	}
}