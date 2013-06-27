package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	
	import flash.utils.Dictionary;
	
	import mx.formatters.DateFormatter;
	
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
				r.ropewayId = String(int(Math.random() * 100));		
				r.ropewayForce = int(Math.random() * 500);
				r.ropewayTemp = int(Math.random() * 50);
				r.ropewayTime = new Date;
				
				r = AddRopeway(r);
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
				ropewayDict[ropeway.ropewayId] = ropeway;
			}
			
			var r:RopewayVO = ropewayDict[ropeway.ropewayId] as RopewayVO;				
			r.ropewayForce = ropeway.ropewayForce;
			r.ropewayTemp = ropeway.ropewayTemp;
			r.ropewayTime = ropeway.ropewayTime;
			if(!r.todayMin || (r.todayMin > ropeway.ropewayForce))
				r.todayMin = ropeway.ropewayForce;
			if(!r.todayMax || (r.todayMax< ropeway.ropewayForce))
				r.todayMax = ropeway.ropewayForce;
			if(!r.todayAve)
				r.todayAve = ropeway.ropewayForce;
			else
				r.todayAve = (r.todayAve * r.ropewayHistory.length + ropeway.ropewayForce) / (r.ropewayHistory.length + 1);
			
			r.ropewayHistory.push(ropeway);
			
			//var TodayArr:Array = SetTodayarr(r.ropewayHistory);
			//TodayArr.sort(Array.NUMERIC);
			//r.todayMax = TodayArr[TodayArr.length - 1];
			//r.todayMin = TodayArr[0];
			//r.todayAve = GetAve(r.ropewayHistory);
			
			/*var YesArr:Array = SetArr(r.ropewayHistory,"yesd");
			YesArr.sort(Array.NUMERIC);
			r.yesterdayMax = YesArr[YesArr.length - 1];
			r.yesterdayMin = YesArr[0];
			r.yesterdayAve = GetAve(YesArr);*/
			
			return r;
		}
		
		private function SetArr(arr:Array,type:String):Array
		{
			var toarr:Array = new Array();
			var yesarr:Array = new Array();
			
			/*var datenow:Date = new Date;*/
			
			for(var i:int = 0;i < arr.length;i++)
			{
				//var date:Date = arr[i].ropewayTime;
				
				//if(date.date == datenow.date && date.month == datenow.month && date.fullYear == datenow.fullYear) 
					toarr.push(arr[i].ropewayForce);
			}
			return toarr;	
		}
		
		private function GetAve(arr:Array):Number
		{
			var sum:int = 0;
			for(var i:int = 0;i < arr.length;i++)
			{
				sum += arr[i];
			}
			var str:String = (sum/arr.length).toFixed(0);
			return Number(str);
		}
	}
}