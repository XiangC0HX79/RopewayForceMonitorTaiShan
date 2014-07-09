package app.controller
{
	import com.adobe.utils.DateUtil;
	
	import app.model.WindProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifySocketWindCommand extends SimpleCommand
	{		
		/**
		 * 
		 * &&FS|datetime|索道|索道站|支架号|风速|风向|@@
		 * 
		 */					
		override public function execute(notification:INotification):void
		{		
			var array:Array =  notification.getBody() as Array;
			
			var windProxy:WindProxy = facade.retrieveProxy(WindProxy.NAME) as WindProxy;
						
			windProxy.AddItem(
				array[2]
				,int(array[4])
				,DateUtil.parseW3CDTF(String(array[1]).replace(/\s/g,"T") + "+08:00")
				,Number(array[5])
				,Number(array[6])
			);
		}
		
	}
}