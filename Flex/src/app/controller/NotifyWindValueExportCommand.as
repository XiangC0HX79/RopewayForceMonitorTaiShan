package app.controller
{	
	import app.model.WindProxy;
	import app.model.notify.NotifyWindAnalysisValueVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifyWindValueExportCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var notify:NotifyWindAnalysisValueVO = NotifyWindAnalysisValueVO(notification.getBody());
			
			var windPx:WindProxy =  facade.retrieveProxy(WindProxy.NAME) as WindProxy;
			
			windPx.WindValueExport(notify.bracket,notify.sTime,notify.eTime);
		}
	}
}