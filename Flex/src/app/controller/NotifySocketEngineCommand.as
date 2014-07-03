package app.controller
{
	import app.model.EngineProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifySocketEngineCommand extends SimpleCommand
	{			
		/**
		 * 
		 * &&TE|datetime|索道|索道站|位置|温度值|@@
		 * 
		 */			
		override public function execute(notification:INotification):void
		{
			var array:Array =  notification.getBody() as Array;
			
			var engineTempProxy:EngineProxy = facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;	
			
			engineTempProxy.AddItem(
				array[2]
				,new Date(Date.parse(String(array[1]).replace(/-/g,"/")))
				,int(array[4])
				,Number(array[5])
			);
		}
		
	}
}