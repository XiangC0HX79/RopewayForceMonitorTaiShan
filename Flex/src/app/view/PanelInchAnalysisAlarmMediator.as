package app.view
{
	import app.view.components.PanelInchAnalysisAlarm;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelInchAnalysisAlarmMediator extends Mediator
	{
		public static const NAME:String = "PanelInchAnalysisAlarmMediator";
		
		public function PanelInchAnalysisAlarmMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelInchAnalysisAlarm():PanelInchAnalysisAlarm
		{
			return viewComponent as PanelInchAnalysisAlarm;
		}
	}
}