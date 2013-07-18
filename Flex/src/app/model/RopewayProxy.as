package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RopewayProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayProxy";
		
		public function RopewayProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get colRopeway():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function InitRopewayDict():void
		{
			if(ConfigVO.debug)
			{
				var where:String = "";
			}
			else
			{
				where = "DATEDIFF(D,DeteDate,getDate()) = 0";
			}
			
			send("RopeDeteInfoToday_GetList",onRopeCarriageRela_GetLis,where);
		}
		
		private function onRopeCarriageRela_GetLis(event:ResultEvent):void
		{
			var arr:Array = [];
			if(ConfigVO.debug)
			{
				if(event.result.length > 0)
				{
					var rw:RopewayVO = new RopewayVO(event.result[0]);
					
					for(var i:int = 1;i<=2;i++)
					{
						rw.ropewayId = (i < 10)?("0" + i):i.toString();
						rw.ropewayCarId = rw.ropewayId;
					}
					
					arr.push(rw);
				}
			}
			else
			{				
				for each(var o:ObjectProxy in event.result)
				{
					rw = new RopewayVO(o);					
					arr.push(rw);
				}
			}			
			
			colRopeway.source = arr;
			
			trace((new Date).time);
			send("RopeDeteValueHis_GetList",onRopeDeteValueHis_GetList,"DATEDIFF(D,DeteDate,GETDATE()) = 0");
		}
		
		private function onRopeDeteValueHis_GetList(event:ResultEvent):void
		{
			for each(var i:ObjectProxy in event.result)
			{
				var rf:RopewayForceVO = new RopewayForceVO(i);
				var rw:RopewayVO = GetRopeway(rf);
				if(rw)
					rw.ropewayHistory.push(rf);
			}
			
			trace((new Date).time);
			sendNotification(ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE);
		}
		
		public function GetRopeway(ropewayForce:RopewayForceVO):RopewayVO
		{
			for each(var r:RopewayVO in colRopeway)
			{
				if((r.ropewayId == ropewayForce.ropewayId)
					&& (r.ropewayStation == ropewayForce.fromRopeStation))					
					return r;
			}
			
			return null;
		}
		
		public function GetRopewayByStation(station:String):RopewayVO
		{
			var rt:RopewayVO = null;
			for each(var r:RopewayVO in colRopeway)
			{
				if(r.ropewayStation == station)	
				{
					if(!rt)
					{
						rt = r;
					}
				}
			}
			
			return rt;
		}
		
		public function AddRopeway(ropewayForce:RopewayForceVO):AsyncToken
		{
			var token:AsyncToken = send("RopeDeteInfoToday_GetModel",null,ropewayForce.toString());
			
			token.ropewayForce = ropewayForce;
						
			return token;
		}
				
		public function GetRopewayCount(station:String):Number
		{
			var count:Number = 0;
			for each(var r:RopewayVO in colRopeway)
			{
				if(r.ropewayStation == station)
				{
					count++;
				}
			}
			
			return count;
		}
	}
}