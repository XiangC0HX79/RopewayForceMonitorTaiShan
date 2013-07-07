package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayDayAveVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayNumTotelAnaVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RopewayNumTotelAnaProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayNumTotelAnaProxy";
		public function RopewayNumTotelAnaProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new Dictionary);
		}
		
		public function get ropewayDict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function GetTotel(obj:Object):ArrayCollection
		{
			var arr:ArrayCollection = new ArrayCollection();
			var arr2:ArrayCollection = new ArrayCollection();
			for(var i:int;i<=4;i++)
			{
				var r:RopewayNumTotelAnaVO = new RopewayNumTotelAnaVO();	
				r.ropewayId = String(i+1);		
				r.ropewayNum = int(Math.random() * 100);
				r.ropewayStation = "桃花源上站"
				arr.addItem(r);
				var r2:RopewayNumTotelAnaVO = new RopewayNumTotelAnaVO();	
				r2.ropewayId = String(i+1);		
				r2.ropewayNum = int(Math.random() * 100);
				r2.ropewayStation = "桃花源下站"
				arr.addItem(r2);
				var r3:RopewayNumTotelAnaVO = new RopewayNumTotelAnaVO();	
				r3.ropewayId = String(i+6);		
				r3.ropewayNum = int(Math.random() * 100);
				r3.ropewayStation = "中天门上站"
				arr.addItem(r3);
				var r4:RopewayNumTotelAnaVO = new RopewayNumTotelAnaVO();	
				r4.ropewayId = String(i+6);		
				r4.ropewayNum = int(Math.random() * 100);
				r4.ropewayStation = "中天门下站"
				arr.addItem(r4);
			}
			for each(var rt:RopewayNumTotelAnaVO in arr)
			{
				var iswell:int = 0;
				for each(var obj:Object in arr2)
				{
					if(obj.ropewayId == rt.ropewayId)
					{
						if(rt.ropewayStation == "桃花源上站")
							obj.STATION1 = rt.ropewayNum;
						else if(rt.ropewayStation == "桃花源下站")
							obj.STATION2 = rt.ropewayNum;
						else if(rt.ropewayStation == "中天门上站")
							obj.STATION3 = rt.ropewayNum;
						else if(rt.ropewayStation == "中天门下站")
							obj.STATION4 = rt.ropewayNum;
						iswell = 1;
					}
				}
				if(iswell == 0)
				{
					var obj2:Object = new Object();
					obj2.ropewayId = rt.ropewayId;
					if(rt.ropewayStation == "桃花源上站")
						obj2.STATION1 = rt.ropewayNum;
					else if(rt.ropewayStation == "桃花源下站")
						obj2.STATION2 = rt.ropewayNum;
					else if(rt.ropewayStation == "中天门上站")
						obj2.STATION3 = rt.ropewayNum;
					else if(rt.ropewayStation == "中天门下站")
						obj2.STATION4 = rt.ropewayNum;
					arr2.addItem(obj2);
				}
			}
			return arr2;
		}
	}
}