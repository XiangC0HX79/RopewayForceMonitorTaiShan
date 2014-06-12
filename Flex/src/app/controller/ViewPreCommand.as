package app.controller
{	
	import spark.components.Application;
	
	import app.view.AlertMediator;
	import app.view.ApplicationMediator;
	import app.view.ChartRealtimeDetectionMediator;
	import app.view.ContentForceAnalysisMediator;
	import app.view.ContentEngineTempRealtimeDetectionMediator;
	import app.view.ContentForceManageMediator;
	import app.view.ContentRealtimeDetectionMediator;
	import app.view.ContentTodayOverviewMediator;
	import app.view.LoadingBarMediator;
	import app.view.MainPanelEngineTempMediator;
	import app.view.MainPanelForceMediator;
	import app.view.MainPanelOverviewMediator;
	import app.view.PanelAnalysisAlarmMediator;
	import app.view.PanelAnalysisForceAverageMediator;
	import app.view.PanelForceAnalysisForceMediator;
	import app.view.PanelAnalysisOpenCountMediator;
	import app.view.PanelAnalysisOpenCountTotalMediator;
	import app.view.PanelForceManagerAdjustMediator;
	import app.view.PanelForceManagerBaseInfoMediator;
	import app.view.PanelRopewayAlarmMediator;
	import app.view.PanelRopewayForceMediator;
	import app.view.PanelRopewayTempMediator;
	import app.view.SocketMediator;
	import app.view.TitleWindowAlarmDealMediator;
	import app.view.TitleWindowBaseInfoMediator;
	import app.view.ToolbarTopMediator;
	import app.view.components.ContentForceAnalysis;
	import app.view.components.ContentForceManage;
	import app.view.components.ContentRealtimeDetection;
	import app.view.components.ContentTodayOverview;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ViewPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var application:RopewayForceMonitor = note.getBody() as RopewayForceMonitor;
			
			facade.registerMediator(new AlertMediator);
			
			facade.registerMediator(new SocketMediator);
			
			facade.registerMediator(new ApplicationMediator(application));
			
			facade.registerMediator(new LoadingBarMediator(application.mainLoading));
			
			facade.registerMediator(new ToolbarTopMediator(application.toolbarTop));
			
			facade.registerMediator(new MainPanelOverviewMediator);
			
			facade.registerMediator(new MainPanelForceMediator);
			
			facade.registerMediator(new MainPanelEngineTempMediator);
			
			facade.registerMediator(new ContentEngineTempRealtimeDetectionMediator);
						
			//facade.registerMediator(new PanelRopewayForceMediator);
			
			//facade.registerMediator(new PanelRopewayTempMediator);
			
			//facade.registerMediator(new PanelRopewayAlarmMediator);
			
			//facade.registerMediator(new ChartRealtimeDetectionMediator);
			
			facade.registerMediator(new ContentRealtimeDetectionMediator(new ContentRealtimeDetection));
			
			facade.registerMediator(new ContentTodayOverviewMediator(new ContentTodayOverview));
			
			facade.registerMediator(new PanelForceAnalysisForceMediator);		
			
			facade.registerMediator(new PanelAnalysisForceAverageMediator);		
			
			facade.registerMediator(new PanelAnalysisOpenCountMediator);	
			
			facade.registerMediator(new PanelAnalysisOpenCountTotalMediator);	
			
			facade.registerMediator(new PanelAnalysisAlarmMediator);			
			
			facade.registerMediator(new ContentForceAnalysisMediator(new ContentForceAnalysis));
			
			facade.registerMediator(new PanelForceManagerBaseInfoMediator);	
			
			facade.registerMediator(new PanelForceManagerAdjustMediator);			
			
			facade.registerMediator(new ContentForceManageMediator(new ContentForceManage));
			
			facade.registerMediator(new TitleWindowAlarmDealMediator);
			
			facade.registerMediator(new TitleWindowBaseInfoMediator);
		}
	}
}