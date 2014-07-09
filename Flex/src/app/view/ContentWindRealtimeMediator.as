package app.view
{	
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	import app.view.components.ContentWindRealtime;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ContentWindRealtimeMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentWindRealtimeMediator";
		
		public function ContentWindRealtimeMediator()
		{
			super(NAME, new ContentWindRealtime);
		}
		
		protected function get contentWindRealtime():ContentWindRealtime
		{
			return viewComponent as ContentWindRealtime;
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
					contentWindRealtime.ropeway = RopewayVO(notification.getBody());
					break;
			}
		}
	}
}