package app.view
{
	import app.ApplicationFacade;
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
		}
		
		protected function get panelRopewayForce():PanelRopewayForce
		{
			return viewComponent as PanelRopewayForce;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
				ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:
					panelRopewayForce.ropeway = notification.getBody() as RopewayVO;
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME:
					panelRopewayForce.ropeway = notification.getBody() as RopewayVO;
					panelRopewayForce.UpdateLabel();
					break;
			}
		}
	}
}