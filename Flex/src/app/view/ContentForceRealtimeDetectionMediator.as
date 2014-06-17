package app.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;
	import mx.formatters.DateFormatter;
	
	import app.ApplicationFacade;
	import app.model.CarriageProxy;
	import app.model.ForceRealtimeDetectionAlarmProxy;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.CarriageVO;
	import app.model.vo.RopewayAlarmVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.ContentForceRealtimeDetection;
	import app.view.components.PanelForceAnalysisAlarm;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ContentForceRealtimeDetectionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentForceRealtimeDetectionMediator";
		
		private var carriageProxy:CarriageProxy;
		
		public function ContentForceRealtimeDetectionMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
						
		/*	facade.registerMediator(new PanelForceRopewayForceMediator(contentRealtimeDetection.panelForce));
			facade.registerMediator(new PanelForceRopewayTempMediator(contentRealtimeDetection.panelTemp));
			facade.registerMediator(new PanelForceRopewayAlarmMediator(contentRealtimeDetection.panelAlarm));
			facade.registerMediator(new PanelForceRopewayChartMediator(contentRealtimeDetection.chartForce));*/
			
			contentRealtimeDetection.addEventListener(PanelForceAnalysisAlarm.STATION_CHANGE,onStationChange);
			
			carriageProxy = facade.retrieveProxy(CarriageProxy.NAME) as CarriageProxy;
		}
		
		protected function get contentRealtimeDetection():ContentForceRealtimeDetection
		{
			return viewComponent as ContentForceRealtimeDetection;
		}		
		
		private function onStationChange(event:Event):void
		{			
			changeStation();
		}
		
		private function changeStation():void
		{
			var rs:RopewayStationDict = contentRealtimeDetection.selStation;
			
			contentRealtimeDetection.panelForce.pin = false;
			
			var r:Array = carriageProxy.GetRopewayStationForce(rs);
			
			contentRealtimeDetection.carCount = r.length;
			
			var lastRsf:RopewayStationForceVO;
			for each(var rsf:RopewayStationForceVO in r)
			{
				if(
					!lastRsf || !lastRsf.deteDate 
					|| (rsf.deteDate && (rsf.deteDate.time > lastRsf.deteDate.time))
					)
					lastRsf = rsf;
			}
			
			contentRealtimeDetection.ropewayStationForce = lastRsf;
			
			contentRealtimeDetection.panelAlarm.station = rs;
			
			var forceRealtimeDetectionAlarmProxy:ForceRealtimeDetectionAlarmProxy = facade.retrieveProxy(ForceRealtimeDetectionAlarmProxy.NAME) as ForceRealtimeDetectionAlarmProxy;
			contentRealtimeDetection.panelAlarm.colAlarm = forceRealtimeDetectionAlarmProxy.dict[rs];
		}	
		
		override public function listNotificationInterests():Array
		{
			return [
				//ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				
				ApplicationFacade.NOTIFY_SOCKET_FORCE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					contentRealtimeDetection.colStations = RopewayStationDict.list;	
					
					contentRealtimeDetection.selStation = contentRealtimeDetection.colStations[0];
					
					changeStation();
					break;
				
				case ApplicationFacade.NOTIFY_SOCKET_FORCE:
					var ropewayForce:RopewayStationForceVO = notification.getBody() as RopewayStationForceVO;
					
					if(ropewayForce.ropewayStation == contentRealtimeDetection.selStation)
					{
						contentRealtimeDetection.carCount = carriageProxy.GetRopewayStationForce(ropewayForce.ropewayStation).length;
						
						if(!contentRealtimeDetection.panelForce.pin
							|| (contentRealtimeDetection.ropewayStationForce == ropewayForce))
						{
							contentRealtimeDetection.ropewayStationForce = ropewayForce;
						}
					}
					break;
			}
		}
	}
}