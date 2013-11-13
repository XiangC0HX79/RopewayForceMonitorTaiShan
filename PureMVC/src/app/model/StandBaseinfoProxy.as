package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.ConfigVO;
	import app.model.vo.StandBaseinfoVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.rpc.events.ResultEvent;
	import mx.utils.*;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class StandBaseinfoProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "StandBaseinfoProxy";
		public function StandBaseinfoProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new Dictionary);
		}
		
		public function get standDict():Dictionary
		{
			return data as Dictionary;
		}
		
		private var StandId:int;
		public function InitStandInfo(standid:int):void
		{
			StandId = standid;
			var station:String = FlexGlobals.topLevelApplication.Station;
			var config:ConfigVO = FlexGlobals.topLevelApplication.Config;
			var stationid:int;
			for(var i:int = 0;i < config.stations.length;i++)
			{
				if(station == config.stations[i])
					stationid = config.stationsid[i];
			}
			var where:String = "BracketId = '" + standid + "' and RopeWay = '" + stationid + "'";
			send("T_ME_LineBracketBaseInfo_GetModelList",onInitStandDict,where);
		}
		
		private function onInitStandDict(event:ResultEvent):void
		{
			var arr:ArrayCollection = new ArrayCollection();
			for each(var obj:* in event.result)
			{
				var sb:StandBaseinfoVO = new StandBaseinfoVO(obj);
				arr.addItem(sb);
			}
			sendNotification(ApplicationFacade.NOTIFY_INIT_STANDINFO,sb);
		}
		
		public function UpdataStandInfo(standinfo:StandBaseinfoVO):void
		{
			var s:String = JSON.stringify(standinfo);
			send("T_ME_LineBracketBaseInfo_Update",onUpdataStandInfo,JSON.stringify(standinfo));
		}
		
		private function onUpdataStandInfo(event:ResultEvent):void
		{
			Alert.show("保存成功！");
			InitStandInfo(StandId);
		}
		
	}
}