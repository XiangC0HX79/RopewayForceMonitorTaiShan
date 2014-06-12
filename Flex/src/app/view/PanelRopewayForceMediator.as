package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.PanelRopewayForce;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelRopewayForceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelRopewayForceMediator";
		
		public function PanelRopewayForceMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
			
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
		}
		
		protected function get panelRopewayForce():PanelRopewayForce
		{
			return viewComponent as PanelRopewayForce;
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
						if(panelRopewayForce.ropeway == rw)
							panelRopewayForce.ropeway = rw;		
					}
					else
					{
						panelRopewayForce.ropeway = rw;			
					}
					break;
				
				case ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE:
					var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
					panelRopewayForce.ropeway = proxy.GetRopewayByStation(String(notification.getBody()));
					break;
			}
		}
	}
}