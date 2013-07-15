package app.model
{
	import app.model.vo.RopewayAlarmVO;
	
	import com.adobe.utils.DateUtil;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class RopewayAlarmAnalysisProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayAlarmAnalysisProxy";
		
		public function RopewayAlarmAnalysisProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get colAlarm():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function GetAlarmCol(dateS:Date,dateE:Date,station:String,ropewayId:String):AsyncToken
		{
			var where:String = "";
			where = "AlarmDatetime >= '" + DateUtil.toLocaleW3CDTF(dateS) 
				+ "' AND AlarmDatetime < '" + DateUtil.toLocaleW3CDTF(dateE) + "'";
			
			if(station != "所有索道站")
				where += " AND FromRopeStation = '" + station + "'";
			
			if(ropewayId != "所有抱索器")
				where += " AND RopeCode = '" + ropewayId + "'";
			
			return send("RopeDete_RopeAlarmRecord_GetList",onGetAlarmCol,where);
		}
		
		private function onGetAlarmCol(event:ResultEvent):void
		{			
			var arr:Array = [];
			for each(var o:ObjectProxy in event.result)
			{
				arr.push(new RopewayAlarmVO(o));
			}
			this.colAlarm.source = arr;
		}
	}
}