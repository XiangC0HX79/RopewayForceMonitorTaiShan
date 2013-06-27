package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
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
			
			mainStation.addEventListener(Event.CHANGE,onChange);
		}
		
		protected function get mainStation():MainStation
		{
			return viewComponent as MainStation;
		}
		
		private function onChange(event:Event):void
		{			
			var ropewayProxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			ropewayProxy.RefreshRopewayDict(String(mainStation.rbGroup.selectedValue));
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					var config:ConfigVO = notification.getBody() as ConfigVO;
					mainStation.dpStations = new ArrayCollection(config.stations);
					break;
			}
		}
	}
}