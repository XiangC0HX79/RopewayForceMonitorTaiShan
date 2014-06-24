package app.model
{
	import flash.events.Event;
	
	import mx.controls.SWFLoader;
	import mx.events.FlexEvent;
	import mx.managers.SystemManager;
	
	import app.ApplicationFacade;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeAware;
	
	public class SocketForceProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String = "SocketForceProxy";
		public static const SRNAME:String = "SocketForceProxySR";
		
		private var _loader:SWFLoader;
		
		public function SocketForceProxy()
		{
			super(NAME);
		}
				
		public function load():void
		{
			if(_loader)		
			{
				sendNotification(ApplicationFacade.NOTIFY_SOCKET_FORCE_LOADED,NAME);
				return;
			}
			
			_loader = new SWFLoader;
			_loader.autoLoad = false;
			_loader.addEventListener(Event.COMPLETE,onSWFLoader);
			_loader.load("assets/swf/TanShanForceMonitor.swf");
		}
		
		private function onSWFLoader(event:Event):void
		{			
			event.target.removeEventListener(Event.COMPLETE,onSWFLoader);
			
			var loadedSM:SystemManager=SystemManager(event.target.content);
			loadedSM.addEventListener(FlexEvent.APPLICATION_COMPLETE,onAppInit);
		}
		
		private function onAppInit(event:Event):void
		{
			event.target.removeEventListener(FlexEvent.APPLICATION_COMPLETE,onAppInit);
			
			var moduleForce:IPipeAware = (event.target as SystemManager).application as IPipeAware;
			
			sendNotification(ApplicationFacade.NOTIFY_SOCKET_FORCE_INIT,moduleForce);			
			
			sendNotification(ApplicationFacade.NOTIFY_SOCKET_FORCE_LOADED,NAME);		
		}
		
		public function unloadAndStop():void
		{
			if(_loader)_loader.unloadAndStop();
		}
	}
}