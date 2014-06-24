package app.model
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import app.ApplicationFacade;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class SyncTimerProxy extends Proxy
	{
		public static const NAME:String = "SyncTimerProxy";
		
		private var _oldTime:Date = new Date;
		
		public function SyncTimerProxy()
		{
			super(NAME);
		}
		
		override public function onRegister():void
		{
			var timer:Timer = new Timer(30000);			
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
		}
		
		private function onTimer(event:TimerEvent):void
		{			
			var now:Date = new Date;
			
			if(_oldTime.toLocaleDateString() != now.toLocaleDateString())
				sendNotification(ApplicationFacade.NOTIFY_INIT_APP);
			
			_oldTime = now;
			
			sendNotification(ApplicationFacade.NOTIFY_SOCKET_KEEP);
		}
	}
}