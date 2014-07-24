package app.controller
{	
	import app.controller.notify.AnalysisValueTableNotify;
	import app.model.IAnalysisProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifyValueTableCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var notify:AnalysisValueTableNotify = AnalysisValueTableNotify(notification.getBody());
			IAnalysisProxy(facade.retrieveProxy(notify.analysisProxyName)).GetPageData(notify);
		}
	}
}