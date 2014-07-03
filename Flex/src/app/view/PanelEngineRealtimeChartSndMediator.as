package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.EngineVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelEngineRealtimeChart;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelEngineRealtimeChartSndMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelEngineRealtimeChartSndMediator";
		
		public function PanelEngineRealtimeChartSndMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelEngineRealtimeChart():PanelEngineRealtimeChart
		{
			return viewComponent as PanelEngineRealtimeChart;
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
					panelEngineRealtimeChart.engine = RopewayVO(notification.getBody()).engineSnd;	
					break;
			}
		}		
	}
}