package app.view
{
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
	
	import spark.formatters.DateTimeFormatter;
	
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.ForceRealtimeDetectionAlarmProxy;
	import app.model.RopewayForceAverageProxy;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.ForceVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.PanelForceRopewayAlarm;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelForceRopewayAlarmMediator_Old extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelForceRopewayAlarmMediator";
		
		private var _soundPlay:Sound;
		
		private var _SoundChannel:SoundChannel;
		
		private var ropewayAlarmDealProxy:ForceRealtimeDetectionAlarmProxy;
		
		public function PanelForceRopewayAlarmMediator_Old(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
			
			panelRopewayAlarm.addEventListener(PanelForceRopewayAlarm.VOICE_CHANGE,onVoiceChange);
			panelRopewayAlarm.addEventListener(PanelForceRopewayAlarm.ALARM_DEAL,onAlarmDeal);
			panelRopewayAlarm.addEventListener(PanelForceRopewayAlarm.ALARM_START,onAlarmStart);
			panelRopewayAlarm.addEventListener(PanelForceRopewayAlarm.ALARM_END,onAlarmEnd);
			
			ropewayAlarmDealProxy = facade.retrieveProxy(ForceRealtimeDetectionAlarmProxy.NAME) as ForceRealtimeDetectionAlarmProxy;
			
			_soundPlay = new Sound;
			_soundPlay.load(new URLRequest("assets/msg.mp3"));
		}
		
		protected function get panelRopewayAlarm():PanelForceRopewayAlarm
		{
			return viewComponent as PanelForceRopewayAlarm;
		}
		
		private function onVoiceChange(event:Event):void
		{			
			if(!_SoundChannel)
				return;
			
			if(!panelRopewayAlarm.fade.isPlaying)
				return;
			
			if(panelRopewayAlarm.voice)
			{
				_SoundChannel = _soundPlay.play(0);
			}
			else
			{
				_SoundChannel.stop();				
			}
		}
		
		private function onAlarmStart(event:Event):void
		{			
			if(panelRopewayAlarm.voice)
			{
				_SoundChannel = _soundPlay.play(0);
			}
		}
		
		private function onAlarmEnd(event:Event):void
		{
			if(!_SoundChannel)
				return;
			
			_SoundChannel.stop();
		}
		
		private function onAlarmDeal(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_ALARM_DEAL,panelRopewayAlarm.listAlarm.selectedItem);
		}
		
		private function onGetAlarmDealCol(event:ResultEvent,t:Object):void
		{
			panelRopewayAlarm.fade.play();
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_ROPEWAY_ALARM_REALTIME
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{				
				case ApplicationFacade.NOTIFY_ROPEWAY_ALARM_REALTIME:
					var station:RopewayStationDict = notification.getBody() as RopewayStationDict;
					if(station == panelRopewayAlarm.station)
					{
						var token:AsyncToken = ropewayAlarmDealProxy.GetAlarmDealCol(station);
						token.addResponder(new AsyncResponder(onGetAlarmDealCol,function(e:FaultEvent,t:Object):void{}));
					}
					break;
			}
		}
	}
}