package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayDayAveVO;
	import app.model.vo.RopewayForceVo;
	import app.model.vo.RopewayVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class RopewayForceProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayForceProxy";
		public function RopewayForceProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new Dictionary);
		}
		
		public function get ropewayDict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function GetForce(obj:Object):ArrayCollection
		{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int;i<=30;i++)
			{
				var r:RopewayForceVo = new RopewayForceVo();	
				r.ropewayId = String(int(Math.random() * 100));		
				r.ropewayForce = int(Math.random() * 500);
				r.ropewayTemp = int(Math.random() * 50);
				r.ropewayTime = new Date;
				r.ropewayStation = "桃花源"
				arr.addItem(r);
			}
			return arr;
		}
		
		public function GetDayAve(obj:Object):ArrayCollection
		{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int;i<=30;i++)
			{
				var r:RopewayDayAveVO = new RopewayDayAveVO();	
				r.ropewayId = String(int(Math.random() * 100));		
				r.ropewayForce = int(Math.random() * 500);
				r.ropewayTime = new Date;
				r.ropewayStation = "桃花源"
				arr.addItem(r);
			}
			return arr;
		}
		
		public function GetMonthAve(obj:Object):ArrayCollection
		{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int;i<=30;i++)
			{
				var r:RopewayDayAveVO = new RopewayDayAveVO();	
				r.ropewayId = String(int(Math.random() * 100));		
				r.ropewayForce = int(Math.random() * 500);
				r.ropewayTime = new Date;
				r.ropewayStation = "桃花源"
				arr.addItem(r);
			}
			return arr;
		}
	}
}