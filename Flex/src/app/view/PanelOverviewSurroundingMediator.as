package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelOverviewSurrounding;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelOverviewSurroundingMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelOverviewSurroundingMediator";
		
		public function PanelOverviewSurroundingMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelOverviewSurroundingTemp():PanelOverviewSurrounding
		{
			return viewComponent as PanelOverviewSurrounding;
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
					panelOverviewSurroundingTemp.stationFst = RopewayVO(notification.getBody()).stationFst;
					panelOverviewSurroundingTemp.stationSnd = RopewayVO(notification.getBody()).stationSnd;
					break;
			}
		}		
	}
}