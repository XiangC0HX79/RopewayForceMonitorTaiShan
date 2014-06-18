package forceMonitor.view
{
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.model.RopewayForceProxy;
	import forceMonitor.model.RopewayProxy;
	import forceMonitor.model.vo.RopewayForceVO;
	import forceMonitor.model.vo.RopewayVO;
	import forceMonitor.view.components.ContentAnalysis;
	import forceMonitor.view.components.PanelAnalysisForce;
	
	import forceCustom.itemRenderer.ItemRendererTodayOverview;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.components.NavigatorContent;
	import spark.components.RadioButton;
	import spark.components.RadioButtonGroup;
	
	public class ContentAnalysisMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentAnalysisMediator";
		
		public function ContentAnalysisMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{														
			contentAnalysis.TabN.addChild(facade.retrieveMediator(PanelAnalysisForceMediator.NAME).getViewComponent() as NavigatorContent);
			contentAnalysis.TabN.addChild(facade.retrieveMediator(PanelAnalysisForceAverageMediator.NAME).getViewComponent() as NavigatorContent);
			contentAnalysis.TabN.addChild(facade.retrieveMediator(PanelAnalysisOpenCountMediator.NAME).getViewComponent() as NavigatorContent);
			contentAnalysis.TabN.addChild(facade.retrieveMediator(PanelAnalysisOpenCountTotalMediator.NAME).getViewComponent() as NavigatorContent);
			contentAnalysis.TabN.addChild(facade.retrieveMediator(PanelAnalysisAlarmMediator.NAME).getViewComponent() as NavigatorContent);	
		}	
		
		protected function get contentAnalysis():ContentAnalysis
		{
			return viewComponent as ContentAnalysis;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ForceMonitorFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
				ForceMonitorFacade.NOTIFY_MAIN_ANALYSIS_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForceMonitorFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:
					break;
				
				case ForceMonitorFacade.NOTIFY_MAIN_ANALYSIS_CHANGE:
					var index:Number = Number(notification.getBody());
					contentAnalysis.TabN.selectedIndex = index;
					break;
			}
		}
	}
}