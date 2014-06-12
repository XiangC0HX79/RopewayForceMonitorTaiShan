package app.model
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	import mx.utils.StringUtil;
	
	import app.ApplicationFacade;
	import app.model.dict.RopewayDict;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.CarriageVO;
	import app.model.vo.ForceVO;
	import app.model.vo.RopewayStationForceVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class CarriageProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "CarriageProxy";
		
		public function CarriageProxy()
		{
			super(NAME, new Dictionary);
		}
		
		public function get dict():Dictionary
		{
			return data as Dictionary;
		}
				
		public function GetCarriage(ropeway:RopewayDict):ArrayCollection
		{
			var r:Array = [];
			
			for each(var c:CarriageVO in dict)
			{
				if(c.ropeWay == ropeway)
					r.push(c);
			}
			
			return new ArrayCollection(r);
		}
		
		public function GetCarriageWithForce(rs:RopewayStationDict):ArrayCollection
		{
			var r:Array = [];
			
			for each(var c:CarriageVO in dict)
			{
				if((c.ropeWay == rs.ropeway) 
					&& (
						(c.fstForce && (rs.station == RopewayStationDict.FIRST))
						||
						(c.sndForce && (rs.station == RopewayStationDict.SECOND))
					))  
					r.push(c);
			}
			
			r.sortOn("ropewayCarId");
			
			r.unshift(CarriageVO.ALL);			
						
			return new ArrayCollection(r);
		}
		
		public function Init():AsyncToken
		{
			//var where:String = "FromRopeWay = '" + ropeway.fullName + "'";
			
			return send2("RopeDete_RopeCarriageRela_GetList",onInit,"");
		}
		
		private function onInit(event:ResultEvent):void
		{
			for each(var o:ObjectProxy in event.result)
			{
				var c:CarriageVO = new CarriageVO(o);
				dict[c.id] = c;
			}
		}
		
		public function InitStationForce():AsyncToken
		{
			return send2("RopeDeteInfoToday_GetList",onInitStationForce,"");
		}
		
		private function onInitStationForce(event:ResultEvent):void
		{
			var arr:Array = [];
			for each(var o:ObjectProxy in event.result)
			{
				var rw:RopewayStationForceVO = new RopewayStationForceVO(o);	
				
				for each(var carriage:CarriageVO in dict)
				{
					if((carriage.ropeWay == rw.ropeway) && (carriage.ropewayId == rw.ropewayId))
					{
						if(rw.ropewayStation.station == RopewayStationDict.FIRST)
							carriage.fstForce = rw;
						else if(rw.ropewayStation.station == RopewayStationDict.SECOND)
							carriage.sndForce = rw;
					}
				}
			}
		}
		
		public function NewBaseInfo(baseInfo:CarriageVO):void
		{
			var token:AsyncToken = send("RopeDete_RopeCarriageRela_New",onNewBaseInfo,baseInfo.toString());
			token.info = baseInfo;
		}
		
		private function onNewBaseInfo(event:ResultEvent):void
		{			
			var info:CarriageVO = event.token.info;
			
			if(event.result > 0)
			{
				info.id = Number(event.result);
				
				dict[info.id] = info;
				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"吊箱'" + info.ropewayCarId + "'信息添加成功。");
				
				sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_INFO_SET);
			}
			else
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"吊箱'" + info.ropewayCarId + "'信息添加失败。");				
			}
		}
		
		public function UpdateBaseInfo(baseInfo:CarriageVO):void
		{
			var token:AsyncToken = send("RopeDete_RopeCarriageRela_Update",onUpdateBaseInfo,baseInfo.toString());
			token.info = baseInfo;
		}
		
		private function onUpdateBaseInfo(event:ResultEvent):void
		{
			var info:CarriageVO = event.token.info;
			if(event.result)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"吊箱'" + info.ropewayCarId + "'信息更新成功。");
				
				sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_INFO_SET,"Update");
			}
			else
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,"吊箱'" + info.ropewayCarId + "'信息更新失败。");				
			}
		}
				
		public function UpdateBaseInfoUse(baseInfo:CarriageVO):void
		{
			var token:AsyncToken = send("RopeDete_RopeCarriageRela_Update",onUpdateBaseInfoUse,baseInfo.toString());
			token.info = baseInfo;
		}
		
		private function onUpdateBaseInfoUse(event:ResultEvent):void
		{
			if(event.result)
			{
				sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_INFO_SET);
			}
			else
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,"吊箱变更可用信息失败。");				
			}
		}
		
		public function DelBaseInfo(baseInfo:CarriageVO):void
		{
			var token:AsyncToken = send("RopeDete_RopeCarriageRela_Delete",onDelBaseInfo,baseInfo.toString());
			token.info = baseInfo;
		}
		
		private function onDelBaseInfo(event:ResultEvent):void
		{
			var info:CarriageVO = event.token.info;
			if(event.result)
			{
				delete dict[info.id];
				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"吊箱'" + info.ropewayCarId + "'信息删除成功。");
				
				sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_INFO_SET);
			}
			else
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,"吊箱'" + info.ropewayCarId + "'信息删除失败。");				
			}
		}
	}
}