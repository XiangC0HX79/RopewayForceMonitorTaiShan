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
			send("RopeDeteInfoToday_GetList",onRopeCarriageRela_GetLis,"");
		}
		
		private function onRopeCarriageRela_GetLis(event:ResultEvent):void
		{
			var arr:Array = [];
			for each(var o:ObjectProxy in event.result)
			{
				var rw:RopewayVO = new RopewayVO(o);					
				arr.push(rw);
			}
			
			colRopeway.source = arr;
			
			sendNotification(ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE);
			//send("RopeDeteValueHis_GetList",onRopeDeteValueHis_GetList,"DATEDIFF(D,DeteDate,GETDATE()) = 0");
		}
		
		private function onRopeDeteValueHis_GetList(event:ResultEvent):void
		{
			for each(var i:ObjectProxy in event.result)
			{
				var rf:RopewayForceVO = new RopewayForceVO(i);
				AddRopeway(rf);
			}
						
			sendNotification(ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE);
		}
		
		public function PushRopeway(ropewayForce:RopewayForceVO):RopewayVO
		{
			for each(var r:RopewayVO in colRopeway)
			{
				if((r.ropewayId == ropewayForce.ropewayId)
					&& (r.fromRopeWay == ropewayForce.fromRopeWay))	
				{
					r.push(ropewayForce);					
					return r;
				}
			}
			
			return null;
		}
		
		public function GetRopewayByStation(station:String):RopewayVO
		{
			var rt:RopewayVO = null;
			for each(var r:RopewayVO in colRopeway)
			{
				if((r.ropewayStation == station)
					&& (r.deteDate.toDateString() == (new Date).toDateString()))
				{
					if(!rt)
					{
						rt = r;
					}
					else if(rt.deteDate.time < r.deteDate.time)
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
			/*for each(var r:RopewayVO in colRopeway)
			{
				if(r.ropewayStation == station)
				{
					count++;
				}
			}*/
			
			return count;
		}
	}
}