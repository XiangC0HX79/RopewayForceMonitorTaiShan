package app.controller
{	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Application;
	
	import app.model.AnalysisBracketProxy;
	import app.model.AnalysisEngineProxy;
	import app.model.AnalysisInchProxy;
	import app.model.AppConfigProxy;
	import app.model.AppParamProxy;
	import app.model.EngineProxy;
	import app.model.ForceProxy;
	import app.model.InchProxy;
	import app.model.RopewayProxy;
	import app.model.RopewayStationProxy;
	import app.model.SocketForceProxy;
	import app.model.SocketProxy;
	import app.model.SyncTimerProxy;
	import app.model.BracketProxy;
	import app.model.vo.RopewayStationVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ModelPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{				
			var application:Application = note.getBody() as Application;
			
			facade.registerProxy(new RopewayProxy(application.parameters.ropeway));
			
			facade.registerProxy(new RopewayStationProxy);
			
			facade.registerProxy(new AppParamProxy);
			
			facade.registerProxy(new SyncTimerProxy);
			
			facade.registerProxy(new AppConfigProxy("appconfig.xml"));
			
			facade.registerProxy(new SocketForceProxy);
			
			facade.registerProxy(new SocketProxy);
			
			facade.registerProxy(new EngineProxy);
			
			facade.registerProxy(new InchProxy);
						
			facade.registerProxy(new ForceProxy);
			
			facade.registerProxy(new BracketProxy);
			
			facade.registerProxy(new AnalysisInchProxy);
			
			facade.registerProxy(new AnalysisEngineProxy);
			
			facade.registerProxy(new AnalysisBracketProxy);
		}
	}
}