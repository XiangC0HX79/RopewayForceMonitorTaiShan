package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayAlarmDealProxy;
	import app.model.vo.RopewayAlarmVO;
	import app.view.components.TitleWindowAlarmDeal;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TitleWindowAlarmDealMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TitleWindowAlarmDealMediator";
		
		public function TitleWindowAlarmDealMediator()
		{
			super(NAME, new TitleWindowAlarmDeal);
			
			titleWindowAlarmDeal.addEventListener(CloseEvent.CLOSE,onClose);	
			titleWindowAlarmDeal.addEventListener(TitleWindowAlarmDeal.OK,onOK);
		}
		
		protected function get titleWindowAlarmDeal():TitleWindowAlarmDeal
		{
			return viewComponent as TitleWindowAlarmDeal;
		}
		
		private function onOK(event:Event):void
		{
			if(titleWindowAlarmDeal.textDeal.text == "")
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入处置信息。");
				return;
			}
			
			titleWindowAlarmDeal.ropewayAlarm.dealDesc = titleWindowAlarmDeal.textDeal.text;
			titleWindowAlarmDeal.ropewayAlarm.dealDatetime = new Date;
			var proxy:RopewayAlarmDealProxy = facade.retrieveProxy(RopewayAlarmDealProxy.NAME) as RopewayAlarmDealProxy;
			var token:AsyncToken = proxy.UpdateAlarmDeal(titleWindowAlarmDeal.ropewayAlarm);
			token.addResponder(new AsyncResponder(onUpdateAlarmDeal,function(e:FaultEvent,t:Object):void{}));
		}
		
		private function onUpdateAlarmDeal(event:ResultEvent,t:Object):void
		{
			if(event.result)
			{				
				PopUpManager.removePopUp(titleWindowAlarmDeal);
			}
		}
		
		private function onClose(event:Event):void
		{
			PopUpManager.removePopUp(titleWindowAlarmDeal);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_ROPEWAY_ALARM_DEAL
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_ROPEWAY_ALARM_DEAL:
					titleWindowAlarmDeal.ropewayAlarm = notification.getBody() as RopewayAlarmVO;
					
					PopUpManager.addPopUp(titleWindowAlarmDeal,FlexGlobals.topLevelApplication as DisplayObject,true);
					PopUpManager.centerPopUp(titleWindowAlarmDeal);
					break;
			}
		}
	}
}