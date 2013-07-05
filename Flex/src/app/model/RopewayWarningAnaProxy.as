package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayDayAveVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayWarningAnaVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RopewayWarningAnaProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayWarningAnaProxy";
		public function RopewayWarningAnaProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new Dictionary);
		}
		
		public function get ropewayDict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function GetWarningInfo(obj:Object):ArrayCollection
		{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int;i<=30;i++)
			{
				var r:RopewayWarningAnaVO = new RopewayWarningAnaVO();	
				r.ropewayId = String(int(Math.random() * 100));		
				r.warningType = String(int(Math.random() * 100));
				r.ropewayStation = "桃花源"
				r.ropewayTime = new Date;
				arr.addItem(r);
			}
			return arr;
		}
	}
}