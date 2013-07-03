package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayDayAveVO;
	import app.model.vo.RopewayForceVo;
	import app.model.vo.RopewayNumAnaVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RopewayNumAnaProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayNumAnaProxy";
		public function RopewayNumAnaProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new Dictionary);
		}
		
		public function get ropewayDict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function GetDayNum(obj:Object):ArrayCollection
		{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int;i<=30;i++)
			{
				var r:RopewayNumAnaVO = new RopewayNumAnaVO();	
				r.ropewayId = String(int(Math.random() * 100));		
				r.ropewayNum = int(Math.random() * 100);
				r.ropewayTime = new Date;
				r.ropewayStation = "桃花源"
				arr.addItem(r);
			}
			return arr;
		}
		
		public function GetMonthNum(obj:Object):ArrayCollection
		{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int;i<=30;i++)
			{
				var r:RopewayNumAnaVO = new RopewayNumAnaVO();	
				r.ropewayId = String(int(Math.random() * 100));		
				r.ropewayNum = int(Math.random() * 100);
				r.ropewayTime = new Date;
				r.ropewayStation = "桃花源"
				arr.addItem(r);
			}
			return arr;
		}
	}
}