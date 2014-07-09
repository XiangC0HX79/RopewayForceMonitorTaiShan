package app.view
{
	import app.view.components.PanelWindAnalysisValue;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelWindAnalysisAlarmMediator extends Mediator
	{
		public static const NAME:String = "PanelWindAnalysisAlarmMediator";
		
		public function PanelWindAnalysisAlarmMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelWindAnalysisValue():PanelWindAnalysisValue
		{
			return viewComponent as PanelWindAnalysisValue;
		}
	}
}