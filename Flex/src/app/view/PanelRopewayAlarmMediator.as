package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayAlarmDealProxy;
	import app.model.RopewayForceAverageProxy;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelRopewayAlarm;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.formatters.DateTimeFormatter;
	
	public class PanelRopewayAlarmMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelRopewayAlarmMediator";
		
		private var _soundPlay:Sound;
		
		private var _SoundChannel:SoundChannel;
		
		private var _ropewayAlarmDealProxy:RopewayAlarmDealProxy;
		
		public function PanelRopewayAlarmMediator()
		{
			super(NAME, new PanelRopewayAlarm);
			
			panelRopewayAlarm.addEventListener(PanelRopewayAlarm.VOICE_CHANGE,onVoiceChange);
			panelRopewayAlarm.addEventListener(PanelRopewayAlarm.ALARM_DEAL,onAlarmDeal);
			
			_ropewayAlarmDealProxy = facade.retrieveProxy(RopewayAlarmDealProxy.NAME) as RopewayAlarmDealProxy;
			panelRopewayAlarm.colAlarm = _ropewayAlarmDealProxy.colAlarmDeal;
			
			_soundPlay = new Sound;
			_soundPlay.load(new URLRequest("assets/msg.mp3"));
		}
		
		protected function get panelRopewayAlarm():PanelRopewayAlarm
		{
			return viewComponent as PanelRopewayAlarm;
		}
		
		private function onVoiceChange(event:Event):void
		{			
			if((!panelRopewayAlarm.voice) && (_SoundChannel))
			{
				_SoundChannel.stop();
			}
		}
		
		private function onAlarmDeal(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_ALARM_DEAL,panelRopewayAlarm.listAlarm.selectedItem);
		}
		
		private function onGetAlarmDealCol(event:ResultEvent,t:Object):void
		{
			panelRopewayAlarm.fade.play();
			
			if(panelRopewayAlarm.voice)
			{
				_SoundChannel = _soundPlay.play(0,5);
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				
				ApplicationFacade.NOTIFY_ROPEWAY_ALARM_REALTIME
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					_ropewayAlarmDealProxy.GetAlarmDealCol();
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_ALARM_REALTIME:
					var token:AsyncToken = _ropewayAlarmDealProxy.GetAlarmDealCol();
					token.addResponder(new AsyncResponder(onGetAlarmDealCol,function(e:FaultEvent,t:Object):void{}));
					break;
			}
		}
	}
}