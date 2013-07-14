package app.controller
{	
	import app.view.*;
	import app.view.components.ContentAnalysis;
	import app.view.components.ContentManage;
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
			
			facade.registerMediator(new AlertMediator);
			
			facade.registerMediator(new SocketMediator);
			
			facade.registerMediator(new ApplicationMediator(application));
			
			facade.registerMediator(new LoadingBarMediator(application.mainLoading));
				
			facade.registerMediator(new MainMenuMediator(application.mainMenu));
			
			facade.registerMediator(new MainStationMediator(application.mainStation));
			
			facade.registerMediator(new PanelRopewayCarIdMediator);
			
			facade.registerMediator(new PanelRopewayForceMediator);
			
			facade.registerMediator(new PanelRopewayTempMediator);
			
			facade.registerMediator(new PanelRopewayAlarmMediator);
			
			facade.registerMediator(new ChartRealtimeDetectionMediator);
			
			facade.registerMediator(new ContentRealtimeDetectionMediator(new ContentRealtimeDetection));
			
			facade.registerMediator(new ContentTodayOverviewMediator(new ContentTodayOverview));
			
			facade.registerMediator(new PanelAnalysisForceMediator);		
			
			facade.registerMediator(new PanelAnalysisForceAverageMediator);		
			
			facade.registerMediator(new PanelAnalysisOpenCountMediator);	
			
			facade.registerMediator(new PanelAnalysisOpenCountTotalMediator);	
			
			facade.registerMediator(new PanelAnalysisAlarmMediator);			
			
			facade.registerMediator(new ContentAnalysisMediator(new ContentAnalysis));
			
			facade.registerMediator(new ContentManageMediator(new ContentManage));
		}
	}
}