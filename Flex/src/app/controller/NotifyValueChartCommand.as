package app.controller
{		
	import app.controller.notify.AnalysisValueChartNotify;
	import app.model.IAnalysisProxy;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifyValueChartCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{			
			var notify:AnalysisValueChartNotify = AnalysisValueChartNotify(notification.getBody());
			IAnalysisProxy(facade.retrieveProxy(notify.analysisProxyName)).GetChartList(notify);
		}
	}
}