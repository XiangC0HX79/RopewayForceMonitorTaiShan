package app.controller
{	
	import spark.components.Application;
	
	import app.model.ConfigProxy;
	import app.model.EngineTempProxy;
	import app.model.RopeForceAjustProxy;
	import app.model.RopewayAlarmAnalysisProxy;
	import app.model.ForceRealtimeDetectionAlarmProxy;
	import app.model.CarriageEditHisProxy;
	import app.model.CarriageProxy;
	import app.model.RopewayForceAverageProxy;
	import app.model.RopewayForceProxy;
	import app.model.RopewaySwitchFreqProxy;
	import app.model.RopewaySwitchFreqTotalProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ModelPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			facade.registerProxy(new ConfigProxy);
			facade.registerProxy(new ForceRealtimeDetectionAlarmProxy);
			facade.registerProxy(new RopewayForceProxy);
			facade.registerProxy(new RopewayForceAverageProxy);
			facade.registerProxy(new RopewaySwitchFreqProxy);
			facade.registerProxy(new RopewaySwitchFreqTotalProxy);
			facade.registerProxy(new RopewayAlarmAnalysisProxy);			
			facade.registerProxy(new CarriageProxy);			
			facade.registerProxy(new CarriageEditHisProxy);	
			facade.registerProxy(new RopeForceAjustProxy);
			
			facade.registerProxy(new EngineTempProxy);
		}
	}
}