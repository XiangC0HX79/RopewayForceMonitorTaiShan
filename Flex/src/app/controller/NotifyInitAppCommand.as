package app.controller
{	
	import app.model.AppConfigProxy;
	import app.model.SocketForceProxy;
	import app.model.SocketProxy;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
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
			
			var appConfigPx :ILoadupProxy = new AppConfigProxy("appconfig.xml");
			var socketForcePx :ILoadupProxy = new SocketForceProxy;
			var socketPx :ILoadupProxy = new SocketProxy;
			
			facade.registerProxy( appConfigPx );
			facade.registerProxy( socketForcePx );
			facade.registerProxy( socketPx );
			
			var rAppConfigPx :LoadupResourceProxy = makeAndRegisterLoadupResource( AppConfigProxy.SRNAME, appConfigPx );
			var rSocketForcePx :LoadupResourceProxy = makeAndRegisterLoadupResource( SocketForceProxy.SRNAME, socketForcePx );
			var rSocketPx :LoadupResourceProxy = makeAndRegisterLoadupResource( SocketProxy.SRNAME, socketPx );
						
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