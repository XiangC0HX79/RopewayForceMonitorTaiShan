package app.controller
{
	import app.model.RopewayStationProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifySocketSurroundingCommand extends SimpleCommand
	{
		/**
		 * 
		 * &&ET|datetime|索道|索道站|温度值|湿度值|@@
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			var array:Array =  notification.getBody() as Array;
						
			var rsPx:RopewayStationProxy = facade.retrieveProxy(RopewayStationProxy.NAME) as RopewayStationProxy;
			
			rsPx.updateSurrounding(
				array[3]
				,new Date(Date.parse(String(array[1]).replace(/-/g,"/")))
				,Number(array[4])
				,Number(array[5])
				);
		}
		
	}
}