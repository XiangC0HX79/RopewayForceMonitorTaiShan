package app.view
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import app.ApplicationFacade;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class SyncTimerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "SyncTimerMediator";
		
		private var _oldTime:Date = new Date;
		
		public function SyncTimerMediator()
		{
			super(NAME, new Timer(30000));
			
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
		}
		
		protected function get timer():Timer
		{
			return viewComponent as Timer;
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