package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayForceAverageProxy;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelRopewayAlarm;
	
	import flash.media.Sound;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.formatters.DateTimeFormatter;
	
	public class PanelRopewayAlarmMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelRopewayAlarmMediator";
		
		private var _soundPlay:Sound;
		
		public function PanelRopewayAlarmMediator()
		{
			super(NAME, new PanelRopewayAlarm);
			
			_soundPlay = new Sound;
			_soundPlay.load(new URLRequest("assets/msg.mp3"));
		}
		
		protected function get panelRopewayAlarm():PanelRopewayAlarm
		{
			return viewComponent as PanelRopewayAlarm;
		}
		
		private function alarmShow():void
		{
			panelRopewayAlarm.fade.play();
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME,
				ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME:
					//抱索力检测值 " + RealValue + " 比 "+AlarmType +" "+ compareValue + "  变化超过 " + stanrdValue
					var rw:RopewayVO = notification.getBody() as RopewayVO;
					
					var df:DateTimeFormatter = new DateTimeFormatter();
					df.dateTimePattern = "HH:mm:ss";
					
					if(rw.alarm == 1)
					{						
						var s:String = df.format(rw.deteDate)							
							+ " " + rw.ropewayCarId + " 抱索力检测值" + rw.deteValue
							+ "比平均值" + rw.yesterdayAve
							+ "变化超过50。";
						
						panelRopewayAlarm.dataPro.addItemAt(s,0);
						
						alarmShow();
					}
					else if(rw.alarm == 2)
					{			
						var preForce:RopewayForceVO = rw.ropewayHistory[rw.ropewayHistory.length - 2];
						s = df.format(rw.deteDate)							
							+ " " + rw.ropewayCarId + " 抱索力检测值" + rw.deteValue
							+ "比前次值" + preForce.ropewayForce
							+ "变化超过50。";
						
						panelRopewayAlarm.dataPro.addItemAt(s,0);
						
						alarmShow();						
					}
					
					if((panelRopewayAlarm.voice) && (rw.alarm > 0))
					{				
						_soundPlay.play(0,5);
					}
					break;
				
				case ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE:
					panelRopewayAlarm.dataPro.removeAll();
					break;
			}
		}
	}
}