package forceMonitor.view
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
	
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.model.ConfigProxy;
	import forceMonitor.model.RopewayAlarmDealProxy;
	import forceMonitor.model.RopewayBaseinfoProxy;
	import forceMonitor.model.RopewayForceAverageProxy;
	import forceMonitor.model.vo.RopewayForceVO;
	import forceMonitor.model.vo.RopewayVO;
	import forceMonitor.view.components.PanelRopewayAlarm;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
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
			panelRopewayAlarm.addEventListener(PanelRopewayAlarm.ALARM_START,onAlarmStart);
			panelRopewayAlarm.addEventListener(PanelRopewayAlarm.ALARM_END,onAlarmEnd);
						
			_soundPlay = new Sound;
			_soundPlay.load(new URLRequest("assets/msg.mp3"));
		}
		
		override public function onRegister():void
		{			
			_ropewayAlarmDealProxy = facade.retrieveProxy(RopewayAlarmDealProxy.NAME) as RopewayAlarmDealProxy;
			panelRopewayAlarm.colAlarm = _ropewayAlarmDealProxy.colAlarmDeal;
		}		
		
		protected function get panelRopewayAlarm():PanelRopewayAlarm
		{
			return viewComponent as PanelRopewayAlarm;
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
			sendNotification(ForceMonitorFacade.NOTIFY_ROPEWAY_ALARM_DEAL,panelRopewayAlarm.listAlarm.selectedItem);
		}
		
		private function onGetAlarmDealCol(event:ResultEvent,t:Object):void
		{
			panelRopewayAlarm.fade.play();
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ForceMonitorFacade.NOTIFY_INIT_APP_COMPLETE,
				
				ForceMonitorFacade.NOTIFY_MAIN_STATION_CHANGE,
				
				ForceMonitorFacade.NOTIFY_ROPEWAY_ALARM_REALTIME
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			
			switch(notification.getName())
			{
				case ForceMonitorFacade.NOTIFY_INIT_APP_COMPLETE:
					_ropewayAlarmDealProxy.InitAlarmDealCol(configProxy.config.stations[0]);
					break;				
				
				case ForceMonitorFacade.NOTIFY_MAIN_STATION_CHANGE:
					_ropewayAlarmDealProxy.InitAlarmDealCol(String(notification.getBody()));
					break;
				
				case ForceMonitorFacade.NOTIFY_ROPEWAY_ALARM_REALTIME:
					var token:AsyncToken = _ropewayAlarmDealProxy.GetAlarmDealCol(configProxy.config.station);
					token.addResponder(new AsyncResponder(onGetAlarmDealCol,function(e:FaultEvent,t:Object):void{}));
					break;
			}
		}
	}
}