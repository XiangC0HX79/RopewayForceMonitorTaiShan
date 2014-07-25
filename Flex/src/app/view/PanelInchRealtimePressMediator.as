package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelInchRealtimePress;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelInchRealtimePressMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelInchRealtimePressMediator";
		
		public function PanelInchRealtimePressMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelInchPress():PanelInchRealtimePress
		{
			return viewComponent as PanelInchRealtimePress;
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
					panelInchPress.press = RopewayVO(notification.getBody()).press;
					break;
			}
		}		
	}
}