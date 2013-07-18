package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayVO;
	import app.view.components.ChartRealtimeDetection;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ChartRealtimeDetectionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ChartRealtimeDetectionMediator";
		
		private var _ropewayProxy:RopewayProxy;
		
		public function ChartRealtimeDetectionMediator()
		{
			super(NAME, new ChartRealtimeDetection);
			
			_ropewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
		}
		
		protected function get chartRealtimeDetection():ChartRealtimeDetection
		{
			return viewComponent as ChartRealtimeDetection;
		}
		
		private function onClear(event:Event):void
		{
			for each(var r:RopewayVO in _ropewayProxy.colRopeway)
			{
				r.ropewayHistory = new Array;
			}
			
			chartRealtimeDetection.ropeway = null;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
				ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME,
				ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:
					chartRealtimeDetection.ropeway = _ropewayProxy.GetRopewayByStation("桃花源驱动站");
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME:
					var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					var rw:RopewayVO = notification.getBody() as RopewayVO;		
					if(configProxy.config.pin)
					{
						if(chartRealtimeDetection.ropeway == rw)
							chartRealtimeDetection.ropeway = rw;		
					}
					else
					{
						chartRealtimeDetection.ropeway = rw;			
					}
					break;
				
				case ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE:
					chartRealtimeDetection.ropeway = _ropewayProxy.GetRopewayByStation(String(notification.getBody()));
					break;
			}
		}
	}
}