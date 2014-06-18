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
	import app.view.ContentInchAnalysisMediator;
	import app.view.ContentInchManageMediator;
	import app.view.ContentInchRealtimeMediator;
	import app.view.LoadingBarMediator;
	import app.view.MainPanelEngineTempMediator;
	import app.view.MainPanelForceMediator;
	import app.view.MainPanelForceSWFMediator;
	import app.view.MainPanelInchMediator;
	import app.view.MainPanelOverviewMediator;
	import app.view.PanelForceAnalysisAlarmMediator;
	import app.view.PanelForceAnalysisForceAverageMediator;
	import app.view.PanelForceAnalysisForceMediator;
	import app.view.PanelForceAnalysisOpenCountMediator;
	import app.view.PanelForceAnalysisOpenCountTotalMediator;
	import app.view.PanelForceManagerAdjustMediator;
	import app.view.PanelForceManagerBaseInfoMediator;
	import app.view.PanelInchRealtimeAlarmMediator;
	import app.view.PanelInchRealtimeChartMediator;
	import app.view.PanelInchRealtimeTempMediator;
	import app.view.PanelInchRealtimeValueMediator;
	import app.view.PanelOverviewInchMediator;
	import app.view.PanelOverviewSurroundingTempMediator;
	import app.view.SocketMediator;
	import app.view.SyncTimerMediator;
	import app.view.TitleWindowAlarmDealMediator;
	import app.view.TitleWindowBaseInfoMediator;
	import app.view.ToolbarTopMediator;
	import app.view.components.ContentForceAnalysis;
	import app.view.components.ContentForceManage;
	import app.view.components.ContentForceRealtimeDetection;
	import app.view.components.ContentForceTodayOverview;
	import app.view.components.MainPanelForceSWF;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ViewPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var application:TanShanInfoMonitor = note.getBody() as TanShanInfoMonitor;
			
			facade.registerMediator(new AlertMediator);
			
			facade.registerMediator(new SocketMediator);
			
			facade.registerMediator(new SyncTimerMediator);			
			
			facade.registerMediator(new ApplicationMediator(application));
			
			facade.registerMediator(new LoadingBarMediator(application.mainLoading));
			
			facade.registerMediator(new ToolbarTopMediator(application.toolbarTop));
			
			//监测概览			
			facade.registerMediator(new MainPanelOverviewMediator);
			
			//facade.registerMediator(new PanelOverviewSurroundingTempMediator);
			
			//facade.registerMediator(new PanelOverviewInchMediator);
			
			//facade.registerMediator(new MainPanelForceMediator);
			
			facade.registerMediator(new MainPanelForceSWFMediator(new MainPanelForceSWF));
			
			//facade.registerMediator(new MainPanelEngineTempMediator);
			
			//张紧小尺
			facade.registerMediator(new MainPanelInchMediator);
			
			facade.registerMediator(new ContentInchRealtimeMediator);
			
			facade.registerMediator(new ContentInchAnalysisMediator);
			
			facade.registerMediator(new ContentInchManageMediator);
						
			//facade.registerMediator(new PanelInchTempMediator);
			
			//facade.registerMediator(new PanelInchValueMediator);
			
			//facade.registerMediator(new PanelInchAlarmMediator);
			
			//facade.registerMediator(new PanelInchChartMediator);			
			
		/*	facade.registerMediator(new ContentEngineTempRealtimeDetectionMediator);
									
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
			
			facade.registerMediator(new TitleWindowBaseInfoMediator);*/
		}
	}
}