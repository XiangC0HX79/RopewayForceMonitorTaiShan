package app.controller
{	
	import app.view.*;
	import app.view.components.ContentRealtimeDetection;
	import app.view.components.ContentTodayOverview;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import spark.components.Application;
	
	public class ViewPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var application:RopewayForceMonitor = note.getBody() as RopewayForceMonitor;
			
			facade.registerMediator(new SocketMediator);
			
			facade.registerMediator(new ApplicationMediator(application));
			
			facade.registerMediator(new LoadingBarMediator(application.mainLoading));
				
			facade.registerMediator(new MainMenuMediator(application.mainMenu));
			
			facade.registerMediator(new ContentRealtimeDetectionMediator(new ContentRealtimeDetection));
			
			facade.registerMediator(new ContentTodayOverviewMediator(new ContentTodayOverview));
		}
	}
}