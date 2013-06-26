package app.view
{
	import app.ApplicationFacade;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AlertMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "AlertMediator";
				
		private static const ALERT_TITLE:String = "泰山索道抱索力实时监控系统";
		
		[Embed(source="assets/image/icon_error.png")]
		private const ICON_ERROR:Class;
		
		[Embed(source="assets/image/icon_alarm.png")]
		private const ICON_ALARM:Class;
		
		[Embed(source="assets/image/icon_info.png")]
		private const ICON_INFO:Class;
		
		public function AlertMediator()
		{
			super(NAME, null);			
			
			Alert.okLabel = "确定";
			Alert.yesLabel = "是";
			Alert.noLabel = "否";
			Alert.cancelLabel = "取消";
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_ALERT_INFO,
				ApplicationFacade.NOTIFY_ALERT_ALARM,
				ApplicationFacade.NOTIFY_ALERT_ERROR
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			var info:String = "";
			var closeHandle:Function = null;
			var flags:uint = 4;
			var arr:Array;
			
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_ALERT_INFO:
					if(notification.getBody() is String)
					{
						info = notification.getBody() as String;
					}
					else if(notification.getBody() is Array)
					{
						arr = notification.getBody() as Array;
						info = arr[0] as String;
						closeHandle = arr[1] as Function;
						if(arr.length > 2)flags = arr[2];
					}
					
					Alert.show(info,ALERT_TITLE,flags,null,closeHandle,ICON_INFO);
					break;
				
				case ApplicationFacade.NOTIFY_ALERT_ALARM:
					if(notification.getBody() is String)
					{
						info = notification.getBody() as String;
					}
					else if(notification.getBody() is Array)
					{
						arr = notification.getBody() as Array;
						info = arr[0] as String;
						closeHandle = arr[1] as Function;
						if(arr.length > 2)flags = arr[2];
					}
					
					Alert.show(info,ALERT_TITLE,flags,null,closeHandle,ICON_ALARM);
					break;				
				
				case ApplicationFacade.NOTIFY_ALERT_ERROR:
					if(notification.getBody() is String)
					{
						info = notification.getBody() as String;
					}
					else if(notification.getBody() is Array)
					{
						arr = notification.getBody() as Array;
						info = arr[0] as String;
						closeHandle = arr[1] as Function;
						if(arr.length > 2)flags = arr[2];
					}
					
					Alert.show(info,ALERT_TITLE,flags,null,closeHandle,ICON_ERROR);
					break;
			}
		}
	}
}