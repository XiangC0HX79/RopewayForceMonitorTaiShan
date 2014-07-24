package app.controller
{	
	import app.controller.notify.AnalysisNotify;
	import app.model.IAnalysisProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifyValueExportCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var notify:AnalysisNotify = AnalysisNotify(notification.getBody());
			IAnalysisProxy(facade.retrieveProxy(notify.analysisProxyName)).ValueExport(notify);
		}
	}
}