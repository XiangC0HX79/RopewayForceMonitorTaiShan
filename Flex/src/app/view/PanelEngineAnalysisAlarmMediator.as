package app.view
{
	import app.view.components.PanelEngineAnalysisAlarm;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelEngineAnalysisAlarmMediator extends Mediator
	{
		public static const NAME:String = "PanelEngineAnalysisAlarmMediator";
		
		public function PanelEngineAnalysisAlarmMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelEngineAnalysisAlarm():PanelEngineAnalysisAlarm
		{
			return viewComponent as PanelEngineAnalysisAlarm;
		}
	}
}