package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelWindRealtimeMaxWindAndAlarm;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelWindRealtimeMaxWindAndAlertMediator_Old extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelWindRealtimeMaxWindAndAlertMediator";
		
		public function PanelWindRealtimeMaxWindAndAlertMediator_Old(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelWindRealtimeMaxWindAndAlarm():PanelWindRealtimeMaxWindAndAlarm
		{
			return viewComponent as PanelWindRealtimeMaxWindAndAlarm;
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
					panelWindRealtimeMaxWindAndAlarm.ropeway = RopewayVO(notification.getBody());
					break;
			}
		}		
	}
}