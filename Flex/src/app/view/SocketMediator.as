package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayVO;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.Timer;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SocketMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "SocketMediator";
		
		public function SocketMediator()
		{
			super(NAME, new Socket);			
		}
		
		protected function get socket():Socket
		{
			return viewComponent as Socket;
		}
		
		private function onTimer(event:Event):void
		{
			var ropeway:RopewayVO = new RopewayVO;
			ropeway.ropewayId = int(Math.random() * 20);		
			ropeway.ropewayForce = int(Math.random() * 500);
			ropeway.ropewayTemp = int(Math.random() * 50);
			ropeway.ropewayTime = new Date;
			
			var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			ropeway = proxy.AddRopeway(ropeway);
			
			sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME,ropeway);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					var timer:Timer = new Timer(10000);
					timer.addEventListener(TimerEvent.TIMER,onTimer);
					timer.start();
					break;
			}
		}
	}
}