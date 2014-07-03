package app.view
{
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.model.vo.InchVO;
	import app.model.vo.InchValueVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelInchRealtimeChart;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
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
				ApplicationFacade.ACTION_UPDATE_ROPEWAY
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_ROPEWAY:
					panelInchChart.inch = RopewayVO(notification.getBody()).inch;
					break;
			}
		}		
	}
}