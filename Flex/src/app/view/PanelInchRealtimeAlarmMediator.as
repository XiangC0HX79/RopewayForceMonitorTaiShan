package app.view
{
	import app.view.components.PanelInchRealtimeAlarm;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelInchRealtimeAlarmMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelInchAlarmMediator";
		
		public function PanelInchRealtimeAlarmMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelInchAlarm():PanelInchRealtimeAlarm
		{
			return viewComponent as PanelInchRealtimeAlarm;
		}
	}
}