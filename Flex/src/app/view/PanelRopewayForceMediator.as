package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelRopewayForce;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelRopewayForceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelRopewayForceMediator";
		
		public function PanelRopewayForceMediator()
		{
			super(NAME, new PanelRopewayForce);
			
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			panelRopewayForce.config = configProxy.config;
		}
		
		protected function get panelRopewayForce():PanelRopewayForce
		{
			return viewComponent as PanelRopewayForce;
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
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME:
					var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					var rw:RopewayVO = notification.getBody() as RopewayVO;		
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