package app.model
{
	import app.ApplicationFacade;
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
			super(NAME, new Dictionary);
		}
		
		public function get ropewayDict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function InitRopewayDict():void
		{
			send("RopeDeteInfoToday_GetAllList",onRopeCarriageRela_GetLis);
		}
		
		private function onRopeCarriageRela_GetLis(event:ResultEvent):void
		{
			for each(var i:ObjectProxy in event.result)
			{
				var rw:RopewayVO = new RopewayVO(i);
				ropewayDict[rw.ropewayId] = rw;
			}
			
			send("RopeDeteValueHis_GetAllList",onRopeDeteValueHis_GetList);
		}
		
		private function onRopeDeteValueHis_GetList(event:ResultEvent):void
		{
			for each(var i:ObjectProxy in event.result)
			{
				var rf:RopewayForceVO = new RopewayForceVO(i);
				var rw:RopewayVO = ropewayDict[rf.ropewayId];
				if(rw)
				{
					rw.ropewayHistory.push(rf);
				}				
			}
			
			sendNotification(ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,rw);
		}
		
		public function AddRopeway(ropewayForce:RopewayForceVO):AsyncToken
		{
			var token:AsyncToken = send("RopeDeteInfoToday_GetModel",onRopeDeteInfoToday_GetModel,ropewayForce.toString());
			
			token.ropewayForce = ropewayForce;
						
			return token;
		}
		
		private function onRopeDeteInfoToday_GetModel(event:ResultEvent):void
		{
		}
		
		public function getRopeway(station:String):RopewayVO
		{
			var rw:RopewayVO = null;
			for each(var r:RopewayVO in ropewayDict)
			{
				if(r.ropewayStation == station)
				{
					if(!rw || (r.lastRopewayForce.ropewayTime.time > rw.lastRopewayForce.ropewayTime.time))
						rw = r;
				}
			}
			
			return rw;
		}
	}
}