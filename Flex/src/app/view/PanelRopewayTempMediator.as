package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelRopewayTemp;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelRopewayTempMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelRopewayTempMediator";
		
		public function PanelRopewayTempMediator()
		{
			super(NAME, new PanelRopewayTemp);
		}
		
		protected function get panelRopewayTemp():PanelRopewayTemp
		{
			return viewComponent as PanelRopewayTemp;
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
					panelRopewayTemp.ropeway = proxy.getRopeway(String(notification.getBody()));
					break;
			}
		}
	}
}