package app.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Group;
	
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.WheelManageProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.WheelManageVO;
	import app.view.components.MainStation;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainStationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainStationMediator";
		
		public function MainStationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			mainStation.addEventListener(Event.CHANGE,onChange);
			mainStation.addEventListener(MainStation.LOCATE_WHEEL,onLocate);
			mainStation.addEventListener(MainStation.AREA_CHANGE,onAreaChange);
		}
		
		protected function get mainStation():MainStation
		{
			return viewComponent as MainStation;
		}
		
		private function onChange(event:Event):void
		{			
			sendNotification(ApplicationFacade.NOTIFY_INIT_STATION_CHANGE);
		}
		
		private function onLocate(event:Event):void
		{			
			sendNotification(ApplicationFacade.NOTIFY_LOCATE_WHEEL,mainStation.comboWheel.textInput.text);
		}
		
		private function onAreaChange(event:Event):void
		{
			mainStation.colWheel.removeAll();
			
			var areaId:int = int(mainStation.comboArea.selectedItem);
			var wheelManageProxy:WheelManageProxy = facade.retrieveProxy(WheelManageProxy.NAME) as WheelManageProxy;
			for each(var wm:WheelManageVO in wheelManageProxy.wheelDict)
			{
				if((wm.RopeWay == mainStation.rbGroup.selectedValue)
					&& (wm.Is_Delete == 0)
					&& (
						(areaId == 0)  
						|| 
						(wm.LineAreaId == areaId)
						)
					)
				{
					mainStation.colWheel.addItem(wm);
				}
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,
				ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE
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
				
				case ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE:
					mainStation.colWheel.removeAll();
					
					var wheelManageProxy:WheelManageProxy = facade.retrieveProxy(WheelManageProxy.NAME) as WheelManageProxy;
					for each(var wm:WheelManageVO in wheelManageProxy.wheelDict)
					{
						if((wm.RopeWay == mainStation.rbGroup.selectedValue)
							&& (wm.Is_Delete == 0))
						{
							mainStation.colWheel.addItem(wm);
						}
					}
					break;
			}
		}
	}
}