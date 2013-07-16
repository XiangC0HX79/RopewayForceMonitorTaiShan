package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelRopewayAlarm;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.formatters.DateTimeFormatter;
	
	public class PanelRopewayAlarmMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelRopewayAlarmMediator";
		
		public function PanelRopewayAlarmMediator()
		{
			super(NAME, new PanelRopewayAlarm);
		}
		
		protected function get panelRopewayAlarm():PanelRopewayAlarm
		{
			return viewComponent as PanelRopewayAlarm;
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
					var rw:RopewayVO = notification.getBody() as RopewayVO;
					
					var df:DateTimeFormatter = new DateTimeFormatter();
					df.dateTimePattern = "HH:mm:ss";
					
					if(rw.ropewayHistory.length > 1)
					{						
						var prerf:RopewayForceVO = rw.ropewayHistory[rw.ropewayHistory.length-2];
						if(Math.abs(rw.lastRopewayForce.ropewayForce - prerf.ropewayForce) > 50)
						{
							var s:String = df.format(rw.lastRopewayForce.ropewayTime)
								+ " " + rw.ropewayCarId 
								+ " 超出前次抱索力50KG。";
							
							panelRopewayAlarm.dataPro.addItemAt(s,0);
						}
					}
					
					if(rw.yesterdayAve > 0)
					{						
						if(Math.abs(rw.lastRopewayForce.ropewayForce - rw.yesterdayAve) > 50)
						{
							s = df.format(rw.lastRopewayForce.ropewayTime)
								+ " " + rw.ropewayCarId
								+ " 超出昨日平均值50KG。";
							
							panelRopewayAlarm.dataPro.addItemAt(s,0);
						}
					}
					break;
				
				case ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE:
					panelRopewayAlarm.dataPro.removeAll();
					break;
			}
		}
	}
}