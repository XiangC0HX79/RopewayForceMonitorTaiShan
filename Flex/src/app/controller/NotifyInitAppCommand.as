package app.controller
{	
	import app.model.AppConfigProxy;
	import app.model.EngineProxy;
	import app.model.InchProxy;
	import app.model.SocketForceProxy;
	import app.model.SocketProxy;
	import app.model.SurroundingProxy;
	import app.model.WindProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.utilities.flex.config.model.ConfigProxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	import org.puremvc.as3.multicore.utilities.loadup.model.LoadupMonitorProxy;
	import org.puremvc.as3.multicore.utilities.loadup.model.LoadupResourceProxy;
	import org.puremvc.as3.multicore.utilities.loadup.model.RetryParameters;
	import org.puremvc.as3.multicore.utilities.loadup.model.RetryPolicy;
	
	public class NotifyInitAppCommand extends SimpleCommand implements ICommand
	{
		//private static const INITCOUNT:Number = 1;
		
		//private static var _init:Number;
						
		private var monitor :LoadupMonitorProxy;
		
		override public function execute(note:INotification):void
		{
			facade.registerProxy( new LoadupMonitorProxy() );
			this.monitor = facade.retrieveProxy( LoadupMonitorProxy.NAME ) as LoadupMonitorProxy;
			this.monitor.defaultRetryPolicy = new RetryPolicy(new RetryParameters) ;
			
			var appConfigPx :ILoadupProxy = ILoadupProxy(facade.retrieveProxy(ConfigProxy.NAME));
			var socketForcePx :ILoadupProxy = ILoadupProxy(facade.retrieveProxy(SocketForceProxy.NAME));
			var socketPx :ILoadupProxy = ILoadupProxy(facade.retrieveProxy(SocketProxy.NAME));
			var surroundingPx :ILoadupProxy = ILoadupProxy(facade.retrieveProxy(SurroundingProxy.NAME));
			var enginePx :ILoadupProxy = ILoadupProxy(facade.retrieveProxy(EngineProxy.NAME));
			var inchPx :ILoadupProxy = ILoadupProxy(facade.retrieveProxy(InchProxy.NAME));
			var windPx :ILoadupProxy = ILoadupProxy(facade.retrieveProxy(WindProxy.NAME));
			
		/*	facade.registerProxy( appConfigPx );
			facade.registerProxy( socketForcePx );
			facade.registerProxy( socketPx );			
			facade.registerProxy( surroundingPx );
			facade.registerProxy( enginePx );
			facade.registerProxy( inchPx );*/
			
			var rAppConfigPx :LoadupResourceProxy = makeAndRegisterLoadupResource( AppConfigProxy.SRNAME, appConfigPx );
			var rSocketForcePx :LoadupResourceProxy = makeAndRegisterLoadupResource( SocketForceProxy.SRNAME, socketForcePx );
			var rSocketPx :LoadupResourceProxy = makeAndRegisterLoadupResource( SocketProxy.SRNAME, socketPx );
			var rSurroundingPx :LoadupResourceProxy = makeAndRegisterLoadupResource( SurroundingProxy.SRNAME, surroundingPx );
			var rEnginePx :LoadupResourceProxy = makeAndRegisterLoadupResource( EngineProxy.SRNAME, enginePx );
			var rInchPx :LoadupResourceProxy = makeAndRegisterLoadupResource( InchProxy.SRNAME, inchPx );
			var rWindPx :LoadupResourceProxy = makeAndRegisterLoadupResource( WindProxy.SRNAME, windPx );
						
			rSocketPx.requires = [rAppConfigPx];
			
			monitor.loadResources();			
		}
		
		private function makeAndRegisterLoadupResource( proxyName :String, appResourceProxy :ILoadupProxy ):LoadupResourceProxy 
		{
			var r :LoadupResourceProxy = new LoadupResourceProxy( proxyName, appResourceProxy );
			facade.registerProxy( r );
			monitor.addResource( r );
			return r;
		}
	}
}