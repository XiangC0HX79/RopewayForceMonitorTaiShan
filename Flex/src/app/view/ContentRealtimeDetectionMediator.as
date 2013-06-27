package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	import app.view.components.ContentRealtimeDetection;
	
	import mx.formatters.DateFormatter;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ContentRealtimeDetectionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentRealtimeDetectionMediator";
		
		public function ContentRealtimeDetectionMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get contentRealtimeDetection():ContentRealtimeDetection
		{
			return viewComponent as ContentRealtimeDetection;
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
					contentRealtimeDetection.ropeway = notification.getBody() as RopewayVO;
					contentRealtimeDetection.numtimes = contentRealtimeDetection.ropeway.ropewayHistory.length;
					contentRealtimeDetection.date = formatDate(contentRealtimeDetection.ropeway.ropewayTime);
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME:
					contentRealtimeDetection.ropeway = notification.getBody() as RopewayVO;
					contentRealtimeDetection.numtimes = contentRealtimeDetection.ropeway.ropewayHistory.length;
					contentRealtimeDetection.date = formatDate(contentRealtimeDetection.ropeway.ropewayTime);
					//contentRealtimeDetection.linechart1.dataProvider = contentRealtimeDetection.ropeway.ropewayHistory;
					contentRealtimeDetection.UpdateChart();
					break;
			}
		}
		
		private function formatDate(date:Date):String
		{
			var dateFormatter:DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
			var nowData:String= dateFormatter.format(date); 
			return nowData;
		}
	}
}