package app.controller
{	
	import spark.components.Application;
	
	import app.view.AlertMediator;
	import app.view.ApplicationMediator;
	import app.view.ContentEngineTempRealtimeDetectionMediator;
	import app.view.ContentForceAnalysisMediator;
	import app.view.ContentForceManageMediator;
	import app.view.ContentForceRealtimeDetectionMediator;
	import app.view.ContentForceTodayOverviewMediator;
	import app.view.LoadingBarMediator;
	import app.view.MainPanelEngineTempMediator;
	import app.view.MainPanelForceMediator;
	import app.view.MainPanelOverviewMediator;
	import app.view.PanelForceAnalysisAlarmMediator;
	import app.view.PanelForceAnalysisForceAverageMediator;
	import app.view.PanelForceAnalysisForceMediator;
	import app.view.PanelForceAnalysisOpenCountMediator;
	import app.view.PanelForceAnalysisOpenCountTotalMediator;
	import app.view.PanelForceManagerAdjustMediator;
	import app.view.PanelForceManagerBaseInfoMediator;
	import app.view.SocketMediator;
	import app.view.SyncTimerMediator;
	import app.view.TitleWindowAlarmDealMediator;
	import app.view.TitleWindowBaseInfoMediator;
	import app.view.ToolbarTopMediator;
	import app.view.components.ContentForceAnalysis;
	import app.view.components.ContentForceManage;
	import app.view.components.ContentForceRealtimeDetection;
	import app.view.components.ContentForceTodayOverview;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ViewPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var application:RopewayForceMonitor = note.getBody() as RopewayForceMonitor;
			
			facade.registerMediator(new AlertMediator);
			
			facade.registerMediator(new SocketMediator);
			
			facade.registerMediator(new SyncTimerMediator);			
			
			facade.registerMediator(new ApplicationMediator(application));
			
			facade.registerMediator(new LoadingBarMediator(application.mainLoading));
			
			facade.registerMediator(new ToolbarTopMediator(application.toolbarTop));
			
			facade.registerMediator(new MainPanelOverviewMediator);
			
			facade.registerMediator(new MainPanelForceMediator);
			
			facade.registerMediator(new MainPanelEngineTempMediator);
			
			facade.registerMediator(new ContentEngineTempRealtimeDetectionMediator);
						
			//facade.registerMediator(new PanelForceRopewayForceMediator);
			
			//facade.registerMediator(new PanelForceRopewayTempMediator);
			
			//facade.registerMediator(new PanelForceRopewayAlarmMediator);
			
			//facade.registerMediator(new ChartRealtimeDetectionMediator);
			
			facade.registerMediator(new ContentForceRealtimeDetectionMediator(new ContentForceRealtimeDetection));
			
			facade.registerMediator(new ContentForceTodayOverviewMediator(new ContentForceTodayOverview));
			
			facade.registerMediator(new PanelForceAnalysisForceMediator);		
			
			facade.registerMediator(new PanelForceAnalysisForceAverageMediator);		
			
			facade.registerMediator(new PanelForceAnalysisOpenCountMediator);	
			
			facade.registerMediator(new PanelForceAnalysisOpenCountTotalMediator);	
			
			facade.registerMediator(new PanelForceAnalysisAlarmMediator);			
			
			facade.registerMediator(new ContentForceAnalysisMediator(new ContentForceAnalysis));
			
			facade.registerMediator(new PanelForceManagerBaseInfoMediator);	
			
			facade.registerMediator(new PanelForceManagerAdjustMediator);			
			
			facade.registerMediator(new ContentForceManageMediator(new ContentForceManage));
			
			facade.registerMediator(new TitleWindowAlarmDealMediator);
			
			facade.registerMediator(new TitleWindowBaseInfoMediator);
		}
	}
}