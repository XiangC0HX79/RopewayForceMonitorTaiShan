package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayVO;
	import app.view.components.MainStation;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Group;
	
	public class MainStationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainStationMediator";
		
		public function MainStationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			mainStation.addEventListener(MainStation.GROUP_CHANGE,onGroupChange);
		}
		
		protected function get mainStation():MainStation
		{
			return viewComponent as MainStation;
		}
		
		private function onGroupChange(event:Event):void
		{			
			updateCarCount();
			
			sendNotification(ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE,mainStation.config.station);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,
				ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					mainStation.config = notification.getBody() as ConfigVO;
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME:	
					updateCarCount();
					break;
			}
		}
		
		private function updateCarCount():void
		{
			var ropewayProxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			mainStation.carCount = ropewayProxy.getRopewayCount(mainStation.config.station);
		}
	}
}