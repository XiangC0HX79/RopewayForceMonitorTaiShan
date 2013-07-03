package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	
	import flash.utils.Dictionary;
	
	import mx.formatters.DateFormatter;
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
		
		public function InitRopewayDict(station:String):void
		{
			for(var i:Number = 0;i<100;i++)
			{				
				var r:RopewayVO = new RopewayVO;					
				r.ropewayId = StringUtil.repeat("0",4 - i.toString().length) + i.toString();	
				ropewayDict[r.ropewayId] = r;
			}
			
			InitRopewayHistory(station);
		}
		
		private function InitRopewayHistory(station:String):void
		{
			var now:Date = new Date;
			
			for(var i:Number = 0;i<5000;i++)
			{			
				var r:RopewayVO = new RopewayVO;		
				var s:String = String(int(Math.random() * 100));					
				r.ropewayId = StringUtil.repeat("0",4 - s.length) + s;
				r.ropewayForce = 500 + int(Math.random() * 150);
				r.ropewayUnit = "KG";
				r.ropewayTemp = int(Math.random() * 50);
				//r.ropewayTime = new Date;
				
				r = AddRopeway(r);
			}
			
			for(i = 0;i<100;i++)
			{								
				var id:String = StringUtil.repeat("0",4 - i.toString().length) + i.toString();	
				r = ropewayDict[id];
				for(var j:Number = 0;j<r.ropewayHistory.length;j++)
				{
					var rh:RopewayVO = r.ropewayHistory[r.ropewayHistory.length - j - 1];
					rh.ropewayTime = new Date(now.time - (50 * 1000) * j); 
				}
			}
			
			sendNotification(ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,r);
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
		
		public function AddRopeway(ropeway:RopewayVO):RopewayVO
		{
			if(!ropewayDict[ropeway.ropewayId])
			{							
				return null;
			}
			
			var r:RopewayVO = ropewayDict[ropeway.ropewayId] as RopewayVO;				
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
			
			return r;
		}
	}
}