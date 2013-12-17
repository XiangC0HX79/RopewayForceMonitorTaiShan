package app.model
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.core.FlexGlobals;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import app.ApplicationFacade;
	import app.model.vo.ConfigVO;
	import app.model.vo.StandConfigVO;
	import app.model.vo.StandMaintainDataVO;
	import app.model.vo.StandMaintainVO;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class StandMaintainProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "StandMaintainProxy";
		public function StandMaintainProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new Dictionary);
		}
		
		public function get standMaintainDict():Dictionary
		{
			return data as Dictionary;
		}
		
		private var StandId:int;
		private var config:ConfigVO;
		
		public function InitStandConfig(standid:int):void
		{
			StandId = standid;
			var station:String = FlexGlobals.topLevelApplication.Station;
			var stationid:int;
			config = FlexGlobals.topLevelApplication.Config;
			for(var i:int = 0;i < config.stations.length;i++)
			{
				if(station == config.stations[i])
					stationid = config.stationsid[i];
			}
			var where:String = "RopeWay = " + stationid + "";
			send("T_ME_HolderlCheckItem_GetModelList",onStandconfig,where);
		}
		
		private function onStandconfig(event:ResultEvent):void
		{
			var obj:Object = {};
			obj.RopeWay = FlexGlobals.topLevelApplication.Station;
			obj.CheckItemIdPairs = "";
			obj.CheckItemNamePairs = "";
			
			for each(var item:Object in event.result)
			{
				obj.CheckItemIdPairs += item.Id + ",";
				obj.CheckItemNamePairs += item.ItemName + ",";
			}
			
			if(obj.CheckItemIdPairs != "")
			{
				var s:String = String(obj.CheckItemIdPairs);				
				obj.CheckItemIdPairs = s.substr(0,s.length - 1);
			}
			
			if(obj.CheckItemNamePairs != "")
			{
				s = String(obj.CheckItemNamePairs);				
				obj.CheckItemNamePairs = s.substr(0,s.length - 1);
			}
			
			sendNotification(ApplicationFacade.NOTIFY_INIT_STANDCONFIG,new StandConfigVO(obj));
		}
		
		public function InitStandMaintain(standid:int):void
		{
			StandId = standid;
			var station:String = FlexGlobals.topLevelApplication.Station;
			var stationid:int;
			config = FlexGlobals.topLevelApplication.Config;
			for(var i:int = 0;i < config.stations.length;i++)
			{
				if(station == config.stations[i])
					stationid = config.stationsid[i];
			}
			var where:String = "BracketId = " + standid + " and RopeWay = " + stationid + "";
			send("T_ME_HolderMaintain_GetModelList",onInitStandDict,where);
		}
		
		public function SearchStandMaintain(standid:int,DateWhere:String):void
		{
			StandId = standid;
			var station:String = FlexGlobals.topLevelApplication.Station;
			var stationid:int;
			config = FlexGlobals.topLevelApplication.Config;
			for(var i:int = 0;i < config.stations.length;i++)
			{
				if(station == config.stations[i])
					stationid = config.stationsid[i];
			}
			var where:String = "BracketId = " + standid + " and RopeWay = " + stationid + " and " + DateWhere;
			send("T_ME_HolderMaintain_GetModelList",onInitStandDict,where);
		}
		
		private function onInitStandDict(event:ResultEvent):void
		{
			var r:Array = JSON.parse(String(event.result)) as Array;
			var arr:ArrayCollection = new ArrayCollection();
			for each(var obj:* in r)
			{
				var sb:StandMaintainVO = new StandMaintainVO(obj);
				for(var i:int = 0;i < config.stations.length;i++)
				{
					if(sb.RopeWay == config.stationsid[i].toString())
						sb.RopeWay = config.stations[i];
				}
				arr.addItem(sb);
			}
			sendNotification(ApplicationFacade.NOTIFY_INIT_STANDMAINTAIN,arr);
		}
		
		public function AddStandMaintain(sm:StandMaintainVO):void
		{
			var o:Object = new Object();
			o.BracketId = sm.BracketId;
			for(var i:int = 0;i < config.stations.length;i++)
			{
				if(sm.RopeWay == config.stations[i])
					o.RopeWay = Number(config.stationsid[i]);
			}
			var dateFormatter:DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
			o.MDate = dateFormatter.format(sm.MDate);
			o.InputUserName = sm.InputUserName;
			o.InputUserId = 0;
			o.Extent1 = "";
			o.Extent2 = "";
			var token:AsyncToken = send("T_ME_HolderMaintain_Add",onaddStandMaintain,JSON.stringify(o.valueOf()));
			token.info = o;
		}
		
		private function onaddStandMaintain(event:ResultEvent):void
		{
			var id:int = new int(event.result);
			sendNotification(ApplicationFacade.NOTIFY_ADD_MAINTAINDATA,id);
		}
		
		public function AddStandMaintainData(id:int,o:Object):void
		{
			var sd:StandMaintainDataVO = new StandMaintainDataVO();
			sd.MId = id;
			sd.CheckItemName = o.CheckItemName;
			sd.CheckItemId = o.CheckItemId;
			sd.CheckData = o.CheckData;
			var token:AsyncToken = send("T_ME_HolderMData_Add",onUpdataStandMaintain,JSON.stringify(sd));
			token.info = o;
		}
		
		
		public function InitStandMaintainData(id:int):void
		{
			var where:String = "Mid = " + id;
			send("T_ME_HolderMData_GetModelList",oninitMaintainData,where);
		}
		
		private function oninitMaintainData(event:ResultEvent):void
		{
			var arr:ArrayCollection = new ArrayCollection();
			for each(var obj:* in event.result)
			{
				var sb:StandMaintainDataVO = new StandMaintainDataVO();
				sb.CheckItemName = obj.CheckItemName;
				sb.CheckData = obj.CheckData;
				arr.addItem(sb);
			}
			sendNotification(ApplicationFacade.NOTIFY_INIT_STANDCONFIG,arr);
		}
		public function EditStandMaintain(sm:StandMaintainVO):void
		{
			var o:Object = new Object();
			o.BracketId = sm.BracketId;
			for(var i:int = 0;i < config.stations.length;i++)
			{
				if(sm.RopeWay == config.stations[i])
					o.RopeWay = config.stationsid[i];
			}
			var dateFormatter:DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
			o.MDate = dateFormatter.format(sm.MDate);
			o.InputUserName = FlexGlobals.topLevelApplication.UserName;
			o.InputUserId = 0;
			o.Extent1 = "";
			o.Extent2 = "";
			o.Id = sm.Id;
			var token:AsyncToken = send("T_ME_HolderMaintain_Update",onUpdataStandMaintain,JSON.stringify(o.valueOf()));
			token.info = o;
		}
		
		public function DeleteStandMaintain(sm:Object):void
		{
			var token:AsyncToken = send("T_ME_HolderMaintain_Delete",onUpdataStandMaintain,sm.Id);
			token.info = sm.Id;
		}
		
		private function onUpdataStandMaintain(event:ResultEvent):void
		{
			InitStandMaintain(StandId);
		}
		
	}
}