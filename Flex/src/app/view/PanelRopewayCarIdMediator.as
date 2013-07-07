package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelRopewayCarId;
	
	import mx.binding.utils.BindingUtils;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelRopewayCarIdMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelRopewayCarIdMediator";
		
		public function PanelRopewayCarIdMediator()
		{
			super(NAME, new PanelRopewayCarId);
		}
		
		protected function get panelRopewayCarId():PanelRopewayCarId
		{
			return viewComponent as PanelRopewayCarId;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,
				ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
				ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME,
				ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					panelRopewayCarId.config = notification.getBody() as ConfigVO;
					break;
				
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME:
					var rw:RopewayVO = notification.getBody() as RopewayVO;		
					if(panelRopewayCarId.config.pin)
					{
						if(panelRopewayCarId.ropeway == rw)
							panelRopewayCarId.ropeway = rw;		
					}
					else
					{
						panelRopewayCarId.ropeway = rw;			
					}
					break;
				
				case ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE:
					var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
					panelRopewayCarId.ropeway = proxy.getRopeway(String(notification.getBody()));
					break;
			}
		}
	}
}