package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
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
		
		
		public function PanelRopewayAlarmMediator()
		{
			super(NAME, new PanelRopewayAlarm);
			
			panelRopewayAlarm.addEventListener(PanelRopewayAlarm.ALARM_DEAL,onAlarmDeal);
			
		}
		
		protected function get panelRopewayAlarm():PanelRopewayAlarm
		{
			return viewComponent as PanelRopewayAlarm;
		}
		
		
		private function onAlarmDeal(event:Event):void
		{
			var obj:Object = panelRopewayAlarm.listAlarm.selectedItem;
			sendNotification(ApplicationFacade.NOTIFY_LOCATE_AREA,obj.areaid,obj.wheelid);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_WARNING_GET,
				
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_WARNING_GET:
					var arr:ArrayCollection = notification.getBody() as ArrayCollection;
					panelRopewayAlarm.listAlarm.dataProvider = arr;
					
					break;
			}
		}
	}
}