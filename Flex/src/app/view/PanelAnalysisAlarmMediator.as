package app.view
{
	import app.view.components.PanelAnalysisAlarm;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelAnalysisAlarmMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisAlarmMediator";
		
		public function PanelAnalysisAlarmMediator()
		{
			super(NAME,new PanelAnalysisAlarm);
		}
		
		protected function get panelAnalysisAlarmMediator():PanelAnalysisAlarmMediator
		{
			return viewComponent as PanelAnalysisAlarmMediator;
		}
	}
}