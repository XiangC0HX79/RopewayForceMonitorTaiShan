package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncToken;
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
		
		public function RefreshRopewayDict(station:String):void
		{
			/*for(var i:Number = 0;i<10000;i++)
			{				
				var r:RopewayVO = new RopewayVO;		
				r.ropewayId = String(int(Math.random() * 100));		
				r.ropewayForce = int(Math.random() * 500);
				r.ropewayTemp = int(Math.random() * 50);
				r.ropewayTime = new Date;
				
				r = AddRopeway(r);
			}
			
			sendNotification(ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,r);*/
		}
		
		public function AddRopeway(ropewayForce:RopewayForceVO):void
		{
			var token:AsyncToken = send("RopeDeteInfoToday_GetModel",onRopeDeteInfoToday_GetModel,ropewayForce.toString());
			token.ropewayForce = ropewayForce;
			/*var r:RopewayVO = ropewayDict[ropeway.ropewayId] as RopewayVO;				
			r.ropewayForce = ropeway.ropewayForce;
			r.ropewayTemp = ropeway.ropewayTemp;
			r.ropewayTime = ropeway.ropewayTime;
			r.ropewayUnit = ropeway.ropewayUnit;
			if(!r.todayMin || (r.todayMin > ropeway.ropewayForce))
				r.todayMin = ropeway.ropewayForce;
			if(!r.todayMax || (r.todayMax< ropeway.ropewayForce))
				r.todayMax = ropeway.ropewayForce;
			if(!r.todayAve)
				r.todayAve = ropeway.ropewayForce;
			else
				r.todayAve = (r.todayAve * r.ropewayHistory.length + ropeway.ropewayForce) / (r.ropewayHistory.length + 1);
			
			r.ropewayHistory.push(ropeway);
			
			return r;*/
		}
		
		private function onRopeDeteInfoToday_GetModel(event:ResultEvent):void
		{
			if(event.result)
			{
				var rw:RopewayVO = new RopewayVO(event.result as ObjectProxy);
				ropewayDict[rw.ropewayId] = rw;				
				rw.ropewayHistory.push(event.token.ropewayForce);
				
				sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME,rw);
			}
		}
	}
}