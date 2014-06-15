package app.model
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.DateUtil;
	
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
		
		public function GetRopewayStationForce(rs:RopewayStationDict):Array
		{			
			var r:Array = [];
			
			for each(var c:CarriageVO in dict)
			{
				if((c.ropeWay == rs.ropeway) && (c.isUse))
				{
					if(c.fstForce 
						&& (rs.station == RopewayStationDict.FIRST)
						&& (c.fstForce.deteDate.toDateString() == (new Date).toDateString())
					)
						r.push(c.fstForce);
					
					if(c.sndForce 
						&& (rs.station == RopewayStationDict.SECOND)
						&& (c.sndForce.deteDate.toDateString() == (new Date).toDateString())
					)
						r.push(c.sndForce);
				}
			}	
			
			r.sortOn("ropewayCarId");
			
			return r;
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
				
		public function GetCarriageWithForceAll(rs:RopewayStationDict):ArrayCollection
		{
			var r:Array = [];
			
			for each(var c:CarriageVO in dict)
			{
				if((c.ropeWay == rs.ropeway) && (c.isUse)
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
			return send2("RopeDete_RopeCarriageRela_GetList",onInit,"");
		}
		
		private function onInit(event:ResultEvent):void
		{
			setData(new Dictionary);
			
			for each(var o:ObjectProxy in event.result)
			{
				var c:CarriageVO = new CarriageVO(o);
				
				var key:String = c.ropeWay.fullName + "|" + c.ropewayId;
				
				dict[key] = c;
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
		
		public function AddForce(force:ForceVO,eletric:String):void
		{
			var rws:RopewayStationDict = RopewayStationDict.dict[force.fromRopeStation];
			if(!rws)return;
			
			var carriageProxy:CarriageProxy = facade.retrieveProxy(CarriageProxy.NAME) as CarriageProxy;			
			var key:String = rws.ropeway.fullName + "|" + force.ropewayId;			
			var carriage:CarriageVO = carriageProxy.dict[key];			
			if(!carriage)return;
			
			carriage.eletric = (eletric == "0");
			
			if(rws.station == RopewayStationDict.FIRST)
			{
				if(carriage.fstForce)
				{
					if(!carriage.fstForce.ropewayHistory)
					{
						var where:String = "RopeCode = '" + carriage.ropewayId + "' AND FromRopeStation = '" + rws.fullName + "' AND DATEDIFF(D,DeteDate,GETDATE()) = 0 AND DeteDate < '" + DateUtil.toLocaleW3CDTF(force.ropewayTime) + "'";						
						var token:AsyncToken = send2("RopeDeteValueHis_GetList",onLoadRopeWayForceHis,where);
						token.ropewayForce = carriage.fstForce;
						token.force = force;
					}
					else
					{
						pushRopewayForce(carriage.fstForce,force);
					}
				}
				else
				{
					var rsf:RopewayStationForceVO = new RopewayStationForceVO(new ObjectProxy);
					rsf.ropeway = rws.ropeway;
					rsf.ropewayStation = rws;
					rsf.ropewayCarId = carriage.ropewayCarId;
					rsf.ropewayId = carriage.ropewayId;
					rsf.ropewayRFId = carriage.ropewayRFID;
					rsf.ropewayHistory = [];
					
					carriage.fstForce = rsf;
					pushRopewayForce(carriage.fstForce,force);
				}
			}
			else if(rws.station == RopewayStationDict.SECOND)
			{
				if(carriage.sndForce)
				{
					if(!carriage.sndForce.ropewayHistory)
					{
						where = "RopeCode = '" + carriage.ropewayId + "' AND FromRopeStation = '" + rws.fullName + "' AND DATEDIFF(D,DeteDate,GETDATE()) = 0 AND DeteDate < '" + DateUtil.toLocaleW3CDTF(force.ropewayTime) + "'";						
						token = send2("RopeDeteValueHis_GetList",onLoadRopeWayForceHis,where);
						token.ropewayForce = carriage.sndForce;
						token.force = force;
					}
					else
					{
						pushRopewayForce(carriage.sndForce,force);
					}
				}
				else
				{
					rsf = new RopewayStationForceVO(new ObjectProxy);
					rsf.ropeway = rws.ropeway;
					rsf.ropewayStation = rws;
					rsf.ropewayCarId = carriage.ropewayCarId;
					rsf.ropewayId = carriage.ropewayId;
					rsf.ropewayRFId = carriage.ropewayRFID;
					rsf.ropewayHistory = [];
					carriage.sndForce = rsf;
					
					pushRopewayForce(carriage.sndForce,force);
				}
			}
			
		}
		
		private function onLoadRopeWayForceHis(event:ResultEvent):void
		{			
			var ropewayForce:RopewayStationForceVO = event.token.ropewayForce;
			var force:ForceVO = event.token.force;
			
			ropewayForce.ropewayHistory = [];
			
			for each(var o:ObjectProxy in event.result)
			{
				var rf:ForceVO = new ForceVO(o);
				pushRopewayForce(ropewayForce,rf,false);
			}
			
			pushRopewayForce(ropewayForce,force);
		}
		
		private function pushRopewayForce(ropeway:RopewayStationForceVO,ropewayForce:ForceVO,notify:Boolean = true):void
		{			
			ropewayForce.alarm = 0;
			ropeway.alarm = 0;
			
			if(ropewayForce.ropewayForce < 400)
			{						
				ropewayForce.alarm |= 4;
				ropeway.alarm |= 4;
			}
			
			if(ropeway.ropewayHistory.length > 0)
			{						
				var prerf:ForceVO = ropeway.ropewayHistory[ropeway.ropewayHistory.length-1];
				if(Math.abs(ropewayForce.ropewayForce - prerf.ropewayForce) > ropeway.ropewayStation.alarmForce)
				{
					ropewayForce.alarm |= 2;
					ropeway.alarm |= 2;
				}
			}
			
			if(ropeway.yesterdayAve > 0)
			{						
				if(Math.abs(ropewayForce.ropewayForce - ropeway.yesterdayAve) > ropeway.ropewayStation.alarmForce)
				{
					ropewayForce.alarm |= 1;
					ropeway.alarm |= 1;
				}
			}
			
			ropeway.deteValue = ropewayForce.ropewayForce;
			ropeway.minValue = ropeway.minValue?Math.min(ropeway.minValue,ropeway.deteValue):ropeway.deteValue;
			ropeway.maxValue = ropeway.maxValue?Math.max(ropeway.maxValue,ropeway.deteValue):ropeway.deteValue;
			ropeway.humidity = ropewayForce.ropewayHumidity;
			ropeway.temperature = ropewayForce.ropewayTemp;
			ropeway.deteDate = ropewayForce.ropewayTime;
			ropeway.valueUnit = ropewayForce.ropewayUnit;
			ropeway.switchFreq++;
			ropeway.switchFreqTotal ++;
			ropeway.totalValue += ropewayForce.ropewayForce;
			ropeway.aveValue = Math.round(ropeway.totalValue / ropeway.switchFreq);
			
			ropeway.ropewayHistory.push(ropewayForce);
			
			if(notify)
				sendNotification(ApplicationFacade.NOTIFY_SOCKET_FORCE,ropeway);
		}
	}
}