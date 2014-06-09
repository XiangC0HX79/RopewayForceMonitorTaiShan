package app.controller
{	
	
	import spark.components.Application;
	
	import app.model.AreaWheelProxy;
	import app.model.ConfigProxy;
	import app.model.HolderMgProxy;
	import app.model.MaintainTypeProxy;
	import app.model.StandBaseinfoProxy;
	import app.model.StandMaintainProxy;
	import app.model.StandProxy;
	import app.model.WebServiceProxy;
	import app.model.WheelHistoryProxy;
	import app.model.WheelManageProxy;
	import app.model.WheelProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ModelPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			facade.registerProxy(new ConfigProxy);
			facade.registerProxy(new WheelProxy);
			facade.registerProxy(new StandProxy);
			facade.registerProxy(new AreaWheelProxy);
			facade.registerProxy(new WheelHistoryProxy);
			facade.registerProxy(new WebServiceProxy);
			facade.registerProxy(new MaintainTypeProxy);
			facade.registerProxy(new WheelManageProxy);
			facade.registerProxy(new StandBaseinfoProxy);
			facade.registerProxy(new StandMaintainProxy);
			facade.registerProxy(new HolderMgProxy);
		}
	}
}