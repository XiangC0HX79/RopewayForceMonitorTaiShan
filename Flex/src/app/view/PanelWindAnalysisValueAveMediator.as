package app.view
{
	import app.view.components.PanelWindAnalysisValue;
	
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelWindAnalysisValueAveMediator extends Mediator
	{
		public static const NAME:String = "PanelWindAnalysisValueAveMediator";
		
		public function PanelWindAnalysisValueAveMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelWindAnalysisValue():PanelWindAnalysisValue
		{
			return viewComponent as PanelWindAnalysisValue;
		}
	}
}