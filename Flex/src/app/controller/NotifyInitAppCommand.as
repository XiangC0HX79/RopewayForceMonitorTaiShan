package app.controller
{	
	import app.model.AppConfigProxy;
	import app.model.AppParamProxy;
	import app.model.EngineProxy;
	import app.model.InchProxy;
	import app.model.RopewayProxy;
	import app.model.RopewayStationProxy;
	import app.model.SocketForceProxy;
	import app.model.SocketProxy;
	import app.model.BracketProxy;
	
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
			var rwPx:ILoadupProxy = ILoadupProxy(facade.retrieveProxy(RopewayProxy.NAME));		
			var rsPx:ILoadupProxy = ILoadupProxy(facade.retrieveProxy(RopewayStationProxy.NAME));		
			var appParamPx:ILoadupProxy = ILoadupProxy(facade.retrieveProxy(AppParamProxy.NAME));				
			var socketForcePx :ILoadupProxy = ILoadupProxy(facade.retrieveProxy(SocketForceProxy.NAME));
			var socketPx :ILoadupProxy = ILoadupProxy(facade.retrieveProxy(SocketProxy.NAME));
			var enginePx :ILoadupProxy = ILoadupProxy(facade.retrieveProxy(EngineProxy.NAME));
			var inchPx :ILoadupProxy = ILoadupProxy(facade.retrieveProxy(InchProxy.NAME));
						
			var rAppConfigPx :LoadupResourceProxy = makeAndRegisterLoadupResource( AppConfigProxy.SRNAME, appConfigPx );
			var rRwPx:LoadupResourceProxy = makeAndRegisterLoadupResource( RopewayProxy.SRNAME, rwPx );
			var rRsPx:LoadupResourceProxy = makeAndRegisterLoadupResource( RopewayStationProxy.SRNAME, rsPx );
			var rAppParamPx:LoadupResourceProxy = makeAndRegisterLoadupResource( AppParamProxy.SRNAME, appParamPx );
			var rSocketForcePx :LoadupResourceProxy = makeAndRegisterLoadupResource( SocketForceProxy.SRNAME, socketForcePx );
			var rSocketPx :LoadupResourceProxy = makeAndRegisterLoadupResource( SocketProxy.SRNAME, socketPx );
			var rEnginePx :LoadupResourceProxy = makeAndRegisterLoadupResource( EngineProxy.SRNAME, enginePx );
			var rInchPx :LoadupResourceProxy = makeAndRegisterLoadupResource( InchProxy.SRNAME, inchPx );
						
			rRsPx.requires = [rRwPx];
			rAppParamPx.requires = [rRwPx];
			rInchPx.requires = [rAppConfigPx,rRwPx];
			rEnginePx.requires = [rAppConfigPx,rRwPx];
			
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