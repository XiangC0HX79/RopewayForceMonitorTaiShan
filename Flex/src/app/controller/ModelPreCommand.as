package app.controller
{	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import app.model.AppConfigProxy;
	import app.model.AppParamProxy;
	import app.model.EngineProxy;
	import app.model.ForceProxy;
	import app.model.InchProxy;
	import app.model.RopewayProxy;
	import app.model.RopewayStationProxy;
	import app.model.SocketForceProxy;
	import app.model.SocketProxy;
	import app.model.SurroundingProxy;
	import app.model.SyncTimerProxy;
	import app.model.WindProxy;
	import app.model.vo.RopewayStationVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ModelPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{			
			facade.registerProxy(new AppParamProxy);
			
			facade.registerProxy(new RopewayProxy);
			
			facade.registerProxy(new RopewayStationProxy);
			
			facade.registerProxy(new SyncTimerProxy);
			
			//ILoadupProxy
			facade.registerProxy(new AppConfigProxy("appconfig.xml"));
			
			facade.registerProxy(new SocketForceProxy);
			
			facade.registerProxy(new SocketProxy);
			
			facade.registerProxy(new EngineProxy);
			
			facade.registerProxy(new InchProxy);
			
			facade.registerProxy(new SurroundingProxy);
			
			facade.registerProxy(new ForceProxy);
			
			facade.registerProxy(new WindProxy);
		}
	}
}