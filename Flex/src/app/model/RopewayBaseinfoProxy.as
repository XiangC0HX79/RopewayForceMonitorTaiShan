package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayBaseinfoVO;
	import app.model.vo.RopewayDayAveVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayNumAnaVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RopewayBaseinfoProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayBaseinfoProxy";
		public function RopewayBaseinfoProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new Dictionary);
		}
		
		public function get ropewayDict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function update():ArrayCollection
		{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int;i<=5;i++)
			{
				var r:RopewayBaseinfoVO = new RopewayBaseinfoVO();	
				r.ropewayId = String(int(Math.random() * 100));		
				r.carId = String(int(Math.random() * 100));
				r.rfId = String(int(Math.random() * 100));
				r.ropewayStation = "桃花源"
				arr.addItem(r);
			}
			return arr;
		}
		
		public function adddata():void
		{
			
		}
		
		public function editdata():void
		{
			
		}
		
		public function deletedata():void
		{
			
		}
	}
}