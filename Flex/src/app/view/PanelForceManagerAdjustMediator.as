package app.view
{
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopeForceAjustProxy;
	import app.model.dict.RopewayDict;
	import app.model.dict.RopewayStationDict;
	import app.view.components.PanelForceManagerAdjust;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelForceManagerAdjustMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanalForceManagerAdjustMediator";
		
		private var _ropeForceAjustProxy:RopeForceAjustProxy;
		
		public function PanelForceManagerAdjustMediator()
		{
			super(NAME, new PanelForceManagerAdjust);
			
			panelManagerAdjust.addEventListener(PanelForceManagerAdjust.AJUST,onAjust);
			panelManagerAdjust.addEventListener(PanelForceManagerAdjust.STATION_CHANGE,onStationChange);
			
			_ropeForceAjustProxy = facade.retrieveProxy(RopeForceAjustProxy.NAME) as RopeForceAjustProxy;
			panelManagerAdjust.colAjustmentHis = _ropeForceAjustProxy.colRopeForceAjust;
		}
		
		protected function get panelManagerAdjust():PanelForceManagerAdjust
		{
			return viewComponent as PanelForceManagerAdjust;
		}
		
		private function onAjust(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,["请确认是否进行抱索力校准？",onAjustConfirm,Alert.YES | Alert.NO]);
		}
		
		private function onAjustConfirm(event:CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				_ropeForceAjustProxy.NewRopeForceAjust(panelManagerAdjust.listRopewayStation.selectedItem,panelManagerAdjust.dateField.selectedDate);
			}
		}
		
		private function onStationChange(event:Event):void
		{
			_ropeForceAjustProxy.GetRopeForceAjustCol(panelManagerAdjust.listRopewayStation.selectedItem);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				//ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					panelManagerAdjust.colStations = RopewayStationDict.list;	
					
					_ropeForceAjustProxy.GetRopeForceAjustCol(panelManagerAdjust.colStations[0]);
					break;
			}
		}
	}
}