package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayForceProxy;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.ContentAnalysis;
	import app.view.components.PanelAnalysisForce;
	
	import custom.itemRenderer.ItemRendererTodayOverview;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.NavigatorContent;
	import spark.components.RadioButton;
	import spark.components.RadioButtonGroup;
	
	public class ContentAnalysisMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentAnalysisMediator";
		
		public function ContentAnalysisMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
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
				ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
				ApplicationFacade.NOTIFY_MAIN_ANALYSIS_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:
					break;
				
				case ApplicationFacade.NOTIFY_MAIN_ANALYSIS_CHANGE:
					var index:Number = Number(notification.getBody());
					contentAnalysis.TabN.selectedIndex = index;
					break;
			}
		}
	}
}