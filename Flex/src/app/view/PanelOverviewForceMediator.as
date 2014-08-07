package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.ForceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelOverviewForce;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelOverviewForceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelOverviewForceMediator";
		
		public function PanelOverviewForceMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelOverviewForce():PanelOverviewForce
		{
			return viewComponent as PanelOverviewForce;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_ROPEWAY
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_ROPEWAY:
					panelOverviewForce.fstForce = (notification.getBody() as RopewayVO).stationFst.force;
					panelOverviewForce.sndForce = (notification.getBody() as RopewayVO).stationSnd.force;
					break;
			}
		}		
	}
}