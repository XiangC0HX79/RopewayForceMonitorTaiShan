package app.view
{
	import app.view.components.PanelAnalysisOpenCountTotal;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelAnalysisOpenCountTotalMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisOpenCountTotalMediator";
		
		public function PanelAnalysisOpenCountTotalMediator()
		{
			super(NAME, new PanelAnalysisOpenCountTotal);
		}
		
		protected function get panelAnalysisOpenCountTotal():PanelAnalysisOpenCountTotal
		{
			return viewComponent as PanelAnalysisOpenCountTotal;
		}
	}
}