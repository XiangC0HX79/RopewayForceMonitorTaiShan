package app.model
{
	import com.adobe.utils.DateUtil;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import app.ApplicationFacade;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.RopewayAlarmVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class ForceRealtimeDetectionAlarmProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "ForceRealtimeDetectionAlarmProxy";
		
		public function ForceRealtimeDetectionAlarmProxy()
		{
			super(NAME, new Dictionary);
		}
		
		public function get dict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function Init():AsyncToken
		{			
			var where:String = "DealDatetime IS Null AND DATEDIFF(d,AlarmDatetime,GETDATE()) = 0";
			
			return send2("T_RopeDete_RopeAlarmRecord_GetAllList",onInit,where);
		}
		
		private function onInit(event:ResultEvent):void
		{			
			setData(new Dictionary);
			
			for each(var rs:RopewayStationDict in RopewayStationDict.dict)
			{
				dict[rs] = new ArrayCollection;
			}
			
			for each(var o:* in event.result)
			{
				var ra:RopewayAlarmVO = new RopewayAlarmVO(o);
				
				if(ra.ropeStation)
					dict[ra.ropeStation].addItem(ra);
			}
		}
		
		/*private var _initToken:AsyncToken;
		public function InitAlarmDealCol(station:String):void
		{
			colAlarmDeal.removeAll();
			
			var where:String = "FromRopeStation = '" + station + "'";
			where += " AND DealDatetime IS Null AND DATEDIFF(d,AlarmDatetime,GETDATE()) = 0";
			
			var pageIndex:Number = 1;
			var pageSize:Number = 20;
			
			_initToken = send("T_RopeDete_RopeAlarmRecord_GetList",onInitAlarmDealCol,where,pageIndex,pageSize);
			_initToken.where = where;
			_initToken.pageIndex = pageIndex;
			_initToken.pageSize = pageSize;
		}
		
		private function onInitAlarmDealCol(event:ResultEvent):void
		{			
			if(_initToken != event.token)
			{
				trace("更换站点");
				return;
			}
			
			var len:int = event.result.length;
			if(len <= 0)
			{				
				trace("查询结束");
				return;
			}
			
			var pageIndex:Number = event.token.pageIndex;
			pageIndex++;
			
			var pageSize:Number = event.token.pageSize;
			var where:String = event.token.where;
			
			_initToken = send("T_RopeDete_RopeAlarmRecord_GetList",onInitAlarmDealCol,where,pageIndex,pageSize);
			_initToken.where = where;
			_initToken.pageIndex = pageIndex;
			_initToken.pageSize = pageSize;
			
			for each(var o:* in event.result)
			{
				colAlarmDeal.addItem(new RopewayAlarmVO(o));
			}
		}*/
		
		public function GetAlarmDealCol(station:RopewayStationDict):AsyncToken
		{
			if(dict[station].length == 0)
			{
				var date:Date = new Date;
				date = new Date(date.fullYear,date.month,date.date);
			}
			else
			{
				var alarm:RopewayAlarmVO = dict[station][0];
				date = alarm.alarmDate;
			}
			
			var where:String = "FromRopeStation = '" + station + "'";
			where += " AND AlarmDatetime > '" + DateUtil.toLocaleW3CDTF(date) + "'";
			where += " AND DealDatetime IS Null";
			
			var token:AsyncToken = send2("T_RopeDete_RopeAlarmRecord_GetAllList",onGetAlarmDealCol,where);
			token.station = station;
			return token;
		}
		
		private function onGetAlarmDealCol(event:ResultEvent):void
		{
			var station:RopewayStationDict = event.token.station as RopewayStationDict;
			for each(var o:* in event.result)
			{
				dict[station].addItemAt(new RopewayAlarmVO(o),0);
			}
		}
		
		public function UpdateAlarmDeal(alarm:RopewayAlarmVO):AsyncToken
		{			
			var token:AsyncToken = send("T_RopeDete_RopeAlarmRecord_Update",onUpdateAlarmDeal,alarm.toString());
			token.station = alarm.ropeStation;
			token.alarm = alarm;
			return token;
		}
		
		private function onUpdateAlarmDeal(event:ResultEvent):void
		{
			if(event.result)
			{
				var alarm:RopewayAlarmVO = event.token.alarm as RopewayAlarmVO;
				var station:RopewayStationDict = event.token.station as RopewayStationDict;
				
				var col:ArrayCollection = dict[station];
				col.removeItemAt(col.getItemIndex(alarm));				
				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"报警处置成功。");
			}
			else
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"报警处置失败。");				
			}
		}		
	}
}