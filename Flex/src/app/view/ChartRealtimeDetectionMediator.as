package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	import app.view.components.ChartRealtimeDetection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ChartRealtimeDetectionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ChartRealtimeDetectionMediator";
		
		public function ChartRealtimeDetectionMediator()
		{
			super(NAME, new ChartRealtimeDetection);
		}
		
		protected function get chartRealtimeDetection():ChartRealtimeDetection
		{
			return viewComponent as ChartRealtimeDetection;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
				ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:
					chartRealtimeDetection.ropeway = notification.getBody() as RopewayVO;
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME:
					chartRealtimeDetection.ropeway = notification.getBody() as RopewayVO;
					chartRealtimeDetection.UpdateChart();
					break;
			}
		}
	}
}