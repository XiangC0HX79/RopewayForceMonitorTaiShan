package app.controller
{	
	import app.view.AlertMediator;
	import app.view.ApplicationMediator;
	import app.view.ContentEngineAnalysisMediator;
	import app.view.ContentEngineManageMediator;
	import app.view.ContentEngineRealtimeMediator;
	import app.view.ContentInchAnalysisMediator;
	import app.view.ContentInchManageMediator;
	import app.view.ContentInchRealtimeMediator;
	import app.view.InfoJunctionMediator;
	import app.view.LoadingBarMediator;
	import app.view.MainPanelEngineMediator;
	import app.view.MainPanelForceSWFMediator;
	import app.view.MainPanelInchMediator;
	import app.view.MainPanelOverviewMediator;
	import app.view.SyncTimerMediator;
	import app.view.ToolbarTopMediator;
	import app.view.components.MainPanelForceSWF;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ViewPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var application:TanShanInfoMonitor = note.getBody() as TanShanInfoMonitor;
			
			facade.registerMediator(new InfoJunctionMediator);
			
			facade.registerMediator(new AlertMediator);
			
			//facade.registerMediator(new SocketMediator);
			
			facade.registerMediator(new SyncTimerMediator);			
			
			facade.registerMediator(new ApplicationMediator(application));
			
			facade.registerMediator(new LoadingBarMediator(application.mainLoading));
			
			facade.registerMediator(new ToolbarTopMediator(application.toolbarTop));
			
			//监测概览			
			facade.registerMediator(new MainPanelOverviewMediator);
						
			//抱索力
			facade.registerMediator(new MainPanelForceSWFMediator(new MainPanelForceSWF));
			
			//动力室
			facade.registerMediator(new MainPanelEngineMediator);
			
			facade.registerMediator(new ContentEngineRealtimeMediator);
			
			facade.registerMediator(new ContentEngineAnalysisMediator);
			
			facade.registerMediator(new ContentEngineManageMediator);
			
			//张紧小尺
			facade.registerMediator(new MainPanelInchMediator);
			
			facade.registerMediator(new ContentInchRealtimeMediator);
			
			facade.registerMediator(new ContentInchAnalysisMediator);
			
			facade.registerMediator(new ContentInchManageMediator);
		}
	}
}