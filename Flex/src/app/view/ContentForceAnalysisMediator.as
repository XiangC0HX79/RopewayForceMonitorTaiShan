package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayForceProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ForceVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.ContentForceAnalysis;
	import app.view.components.PanelForceAnalysisForce;
	
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
	
	public class ContentForceAnalysisMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentForceAnalysisMediator";
		
		public function ContentForceAnalysisMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			contentAnalysis.viewStatck.addChild(facade.retrieveMediator(PanelForceAnalysisForceMediator.NAME).getViewComponent() as NavigatorContent);
			contentAnalysis.viewStatck.addChild(facade.retrieveMediator(PanelAnalysisForceAverageMediator.NAME).getViewComponent() as NavigatorContent);
			contentAnalysis.viewStatck.addChild(facade.retrieveMediator(PanelAnalysisOpenCountMediator.NAME).getViewComponent() as NavigatorContent);
			contentAnalysis.viewStatck.addChild(facade.retrieveMediator(PanelAnalysisOpenCountTotalMediator.NAME).getViewComponent() as NavigatorContent);
			contentAnalysis.viewStatck.addChild(facade.retrieveMediator(PanelAnalysisAlarmMediator.NAME).getViewComponent() as NavigatorContent);
		}
		
		protected function get contentAnalysis():ContentForceAnalysis
		{
			return viewComponent as ContentForceAnalysis;
		}
	}
}