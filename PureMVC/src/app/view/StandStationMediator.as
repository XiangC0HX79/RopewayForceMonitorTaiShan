package app.view
{
	import app.ApplicationFacade;
	import app.view.components.contentcomponents.StandStation;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class StandStationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "StandStationMediator";
		public function StandStationMediator(viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		protected function get mainContent():StandStation
		{
			return viewComponent as StandStation;
		}
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE,
				ApplicationFacade.NOTIFY_INIT_WHEEL_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE:			
					break;
				case ApplicationFacade.NOTIFY_INIT_WHEEL_COMPLETE:			
					break;
			}
		}
	}
}