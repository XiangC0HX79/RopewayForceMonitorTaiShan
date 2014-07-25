package app.controller
{
	import app.model.InchProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifySocketPressCommand extends SimpleCommand
	{		
		/**
		 * 
		 * &&YL|datetime|索道|索道站|温度值|湿度值|测量值|@@
		 * 
		 */			
		
		override public function execute(notification:INotification):void
		{
			var array:Array =  notification.getBody() as Array;
			
			var inchPx:InchProxy = facade.retrieveProxy(InchProxy.NAME) as InchProxy;
			inchPx.AddPress(
				array[2]
				,new Date(Date.parse(String(array[1]).replace(/-/g,"/")))
				,array[6]
				);
		}
		
	}
}