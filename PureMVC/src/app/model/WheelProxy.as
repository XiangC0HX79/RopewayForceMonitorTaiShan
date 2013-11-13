package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.AreaWheelVO;
	import app.model.vo.ConfigVO;
	import app.model.vo.DayRecordVO;
	import app.model.vo.WheelVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.formatters.DateFormatter;
	import mx.rpc.events.ResultEvent;
	import mx.utils.*;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class WheelProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "WheelProxy";
		
		public function WheelProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new Dictionary);
		}
		
		public function get wheelDict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function InitWheelHistory(station:String):void
		{
			var where:String = "RopeWay = '" + station + "'";
			send("V_WheelLastMaintain_GetModelList",onInitWheelDict,where);
		}
		
		private var arr:ArrayCollection = new ArrayCollection();
		private function onInitWheelDict(event:ResultEvent):void
		{
			arr = new ArrayCollection();
			for each(var obj:* in event.result)
			{
				var wh:WheelVO = new WheelVO(obj);
				wh.HourDiff = 0;
				arr.addItem(wh);
			}
			var station:String = FlexGlobals.topLevelApplication.Station;
			var config:ConfigVO = FlexGlobals.topLevelApplication.Config;
			var stationid:int;
			for(var i:int = 0;i < config.stations.length;i++)
			{
				if(station == config.stations[i])
					stationid = config.stationsid[i];
			}
			var where:String = "RopeWay = '" + stationid + "'";
			send("T_ME_DayRecord_GetModelList",onInitDiffhour,where);
			
		}
	
		private function onInitDiffhour(event:ResultEvent):void
		{
			var hourarr:ArrayCollection = new ArrayCollection();
			for each(var o:* in event.result)
			{
				var d:DayRecordVO = new DayRecordVO(o);
				hourarr.addItem(d);
			}
			for each(var wh:WheelVO in arr)
			{ 
				for each(var dr:DayRecordVO in hourarr)
				{
					if(wh.MaintainTime.time < dr.Datetime.time)
					{
						wh.HourDiff += dr.TodayRunTime;
					}
				}
			}
			sendNotification(ApplicationFacade.NOTIFY_INIT_WHEEL_COMPLETE,arr);
		}
	}
}