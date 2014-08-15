package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelInchRealtimeTemp;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelInchRealtimeTempMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelInchTempMediator";
		
		public function PanelInchRealtimeTempMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelInchTemp():PanelInchRealtimeTemp
		{
			return viewComponent as PanelInchRealtimeTemp
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
					panelInchTemp.rs = (notification.getBody() as RopewayVO).stationSnd;
					break;
			}
		}		
	}
}