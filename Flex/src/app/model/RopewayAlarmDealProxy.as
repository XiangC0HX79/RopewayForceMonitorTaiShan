package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayAlarmVO;
	
	import com.adobe.utils.DateUtil;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class RopewayAlarmDealProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayAlarmDealProxy";
		
		public function RopewayAlarmDealProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get colAlarmDeal():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function GetAlarmDealCol():AsyncToken
		{
			if(colAlarmDeal.length == 0)
			{
				var date:Date = new Date;
				date = new Date(date.fullYear,date.month,date.date);
			}
			else
			{
				var alarm:RopewayAlarmVO = colAlarmDeal[0];
				date = alarm.alarmDate;
			}
			
			var where:String = "AlarmDatetime > '" + DateUtil.toLocaleW3CDTF(date) + "'";
			where += " AND DealDatetime IS Null";
			
			return send("T_RopeDete_RopeAlarmRecord_GetList",onGetAlarmDealCol,where);
		}
		
		private function onGetAlarmDealCol(event:ResultEvent):void
		{
			for each(var o:* in event.result)
			{
				colAlarmDeal.addItemAt(new RopewayAlarmVO(o),0);
			}
		}
		
		public function UpdateAlarmDeal(alarm:RopewayAlarmVO):AsyncToken
		{			
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW,"正在处理报警信息...");
			
			var token:AsyncToken = send("T_RopeDete_RopeAlarmRecord_Update",onUpdateAlarmDeal,alarm.toString());
			token.alarm = alarm;
			return token;
		}
		
		private function onUpdateAlarmDeal(event:ResultEvent):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);
			
			if(event.result)
			{
				colAlarmDeal.removeItemAt(colAlarmDeal.getItemIndex(event.token.alarm));				
				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"报警处置成功。");
			}
			else
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"报警处置失败。");				
			}
		}		
	}
}