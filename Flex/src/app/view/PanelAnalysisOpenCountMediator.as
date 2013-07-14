package app.view
{
	import app.view.components.PanelAnalysisOpenCount;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelAnalysisOpenCountMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisOpenCountMediator";
		
		public function PanelAnalysisOpenCountMediator()
		{
			super(NAME, new PanelAnalysisOpenCount);
		}
		
		protected function get panelAnalysisOpenCount():PanelAnalysisOpenCount
		{
			return viewComponent as PanelAnalysisOpenCount;
		}
	}
}