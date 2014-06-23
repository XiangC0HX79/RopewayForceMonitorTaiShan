package forceMonitor.controller
{	
	import forceMonitor.view.*;
	import forceMonitor.view.components.ContentAnalysis;
	import forceMonitor.view.components.ContentManage;
	import forceMonitor.view.components.ContentRealtimeDetection;
	import forceMonitor.view.components.ContentTodayOverview;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
		
	public class ViewPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var application:TanShanForceMonitor = note.getBody() as TanShanForceMonitor;
			
			facade.registerMediator(new ForceJunctionMediator);
			
			facade.registerMediator(new AlertMediator);
			
			facade.registerMediator(new SocketMediator);
			
			facade.registerMediator(new ApplicationMediator(application));
			
			facade.registerMediator(new LoadingBarMediator(application.mainLoading));
				
			facade.registerMediator(new MainMenuMediator(application.mainMenu));
			
			facade.registerMediator(new MainStationMediator(application.mainStation));
						
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
			
			facade.registerMediator(new PanelManagerBaseInfoMediator);	
			
			facade.registerMediator(new PanelManagerAdjustMediator);			
			
			facade.registerMediator(new ContentManageMediator(new ContentManage));
			
			facade.registerMediator(new TitleWindowAlarmDealMediator);
			
			facade.registerMediator(new TitleWindowBaseInfoMediator);
		}
	}
}