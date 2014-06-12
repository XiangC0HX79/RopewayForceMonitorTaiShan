package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.PanelRopewayTemp;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelRopewayTempMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelRopewayTempMediator";
		
		public function PanelRopewayTempMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelRopewayTemp():PanelRopewayTemp
		{
			return viewComponent as PanelRopewayTemp;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				
				ApplicationFacade.NOTIFY_SOCKET_FORCE,
				
				ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
				case ApplicationFacade.NOTIFY_SOCKET_FORCE:
					var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					var rw:RopewayStationForceVO = notification.getBody() as RopewayStationForceVO;		
					if(configProxy.config.pin)
					{
						if(panelRopewayTemp.ropeway == rw)
							panelRopewayTemp.ropeway = rw;		
					}
					else
					{
						panelRopewayTemp.ropeway = rw;			
					}
					break;
				
				case ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE:
					var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
					panelRopewayTemp.ropeway = proxy.GetRopewayByStation(String(notification.getBody()));
					break;
			}
		}
	}
}