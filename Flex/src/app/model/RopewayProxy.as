package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RopewayProxy extends Proxy implements IProxy
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
			for(var i:Number = 0;i<10000;i++)
			{				
				var r:RopewayVO = new RopewayVO;		
				r.ropewayId = String(int(Math.random() * 20));		
				r.ropewayForce = int(Math.random() * 500);
				r.ropewayTemp = int(Math.random() * 50);
				r.ropewayTime = new Date;
				
				r = AddRopeway(r);
			}
			
			
			
			sendNotification(ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,r);
		}
		
		public function AddRopeway(ropeway:RopewayVO):RopewayVO
		{
			if(!ropewayDict[ropeway.ropewayId])
			{							
				ropewayDict[ropeway.ropewayId] = ropeway;
			}
			
			var r:RopewayVO = ropewayDict[ropeway.ropewayId] as RopewayVO;				
			r.ropewayForce = ropeway.ropewayForce;
			r.ropewayTemp = ropeway.ropewayTemp;
			r.ropewayTime = ropeway.ropewayTime;
			r.ropewayHistory.push(ropeway);
			
			var TodayArr:Array = SetTodayarr(r.ropewayHistory);
			TodayArr.sort(Array.NUMERIC);
			r.todayMax = TodayArr[TodayArr.length - 1];
			r.todayMin = TodayArr[0];
			r.todayAve = GetAve(r.ropewayHistory);
			
			return r;
		}
		
		private function SetTodayarr(arr:Array):Array
		{
			var finarr:Array = new Array();
			for(var i:int = 0;i < arr.length;i++)
			{
				finarr.push(arr[i].ropewayForce);
			}
			return finarr;	
		}
		
		private function GetAve(arr:Array):Number
		{
			var sum:int = 0;
			for(var i:int = 0;i < arr.length;i++)
			{
				sum += arr[i].ropewayForce;
			}
			return sum/arr.length;
		}
	}
}