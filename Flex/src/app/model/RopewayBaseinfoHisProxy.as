package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayBaseinfoVO;
	import app.model.vo.RopewayForceVO;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RopewayBaseinfoHisProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayBaseinfoHisProxy";
		
		public function RopewayBaseinfoHisProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get colBaseinfoHis():ArrayCollection
		{
			return data as ArrayCollection;
		}
	}
}