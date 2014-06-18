package forceMonitor.view
{
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.model.ConfigProxy;
	import forceMonitor.model.RopewayProxy;
	import forceMonitor.model.vo.RopewayVO;
	import forceMonitor.view.components.PanelRopewayTemp;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
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
				ForceMonitorFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
				ForceMonitorFacade.NOTIFY_ROPEWAY_INFO_REALTIME,
				ForceMonitorFacade.NOTIFY_MAIN_STATION_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForceMonitorFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:
				case ForceMonitorFacade.NOTIFY_ROPEWAY_INFO_REALTIME:
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
				
				case ForceMonitorFacade.NOTIFY_MAIN_STATION_CHANGE:
					var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
					panelRopewayTemp.ropeway = proxy.GetRopewayByStation(String(notification.getBody()));
					break;
			}
		}
	}
}