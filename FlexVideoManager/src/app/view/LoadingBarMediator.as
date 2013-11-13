package app.view
{	
	import app.view.components.LoadingBar;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class LoadingBarMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "LoadingBarMediator";
		
		public static const DATA_AREA:String 		= "00000001";
		public static const DATA_VIDEO:String 		= "00000010";
		public static const VIEW_IMAGE:String 		= "00000100";
		
		private static const FLAG:Number = 
			parseInt(DATA_AREA,2) |
			parseInt(DATA_VIDEO,2) |
			parseInt(VIEW_IMAGE,2);
		
		private var _flag:Number = 0;
		
		public function LoadingBarMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		private function get loadingBar():LoadingBar
		{
			return viewComponent as LoadingBar;
		}		
		
		private function validInitEnd(flag:String):void
		{				
			_flag |= parseInt(flag,2);
			
			if(_flag == FLAG)
			{
				loadingBar.visible = false;
				
				sendNotification(Notifications.INIT_END);
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.INIT_BEGIN,
				
				Notifications.INIT_DATA_AREA,
				Notifications.INIT_DATA_VIDEO,
				Notifications.INIT_VIEW_IMAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case Notifications.INIT_BEGIN:
					loadingBar.visible = true;
					break;
				
				case Notifications.INIT_DATA_AREA:						
					validInitEnd(DATA_AREA);
					break;
				
				case Notifications.INIT_DATA_VIDEO:						
					validInitEnd(DATA_VIDEO);
					break;
				
				case Notifications.INIT_VIEW_IMAGE:						
					validInitEnd(VIEW_IMAGE);
					break;
			}
		}
	}
}