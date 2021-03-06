package app.controller
{	
	import app.model.*;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import spark.components.Application;
	
	public class ModelPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			facade.registerProxy(new ConfigProxy);
			facade.registerProxy(new RopewayProxy);
			facade.registerProxy(new RopewayAlarmDealProxy);
			facade.registerProxy(new RopewayAlarmProxy);
			facade.registerProxy(new RopewayForceProxy);
			facade.registerProxy(new RopewayForceAverageProxy);
			facade.registerProxy(new RopewaySwitchFreqProxy);
			facade.registerProxy(new RopewaySwitchFreqTotalProxy);
			facade.registerProxy(new RopewayAlarmAnalysisProxy);			
			facade.registerProxy(new RopewayBaseinfoProxy);			
			facade.registerProxy(new RopewayBaseinfoHisProxy);	
			facade.registerProxy(new RopeForceAjustProxy);
		}
	}
}