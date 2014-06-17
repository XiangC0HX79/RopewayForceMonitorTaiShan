package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.InchHistoryVO;
	import app.model.vo.InchVO;
	import app.view.components.PanelInchRealtimeChart;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelInchRealtimeChartMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelInchChartMediator";
		
		public function PanelInchRealtimeChartMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelInchChart():PanelInchRealtimeChart
		{
			return viewComponent as PanelInchRealtimeChart;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_INCH_HISTORY
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_INCH_HISTORY:
					panelInchChart.inchHistory = notification.getBody() as InchHistoryVO;
					break;
			}
		}		
	}
}