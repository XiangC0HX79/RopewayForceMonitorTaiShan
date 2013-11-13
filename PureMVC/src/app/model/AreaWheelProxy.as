package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.AreaWheelVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AreaWheelProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "AreaWheelProxy";
		public function AreaWheelProxy(data:Object=null)
		{
			super(NAME, new Dictionary);
		}
		
		public function get wheelDict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function InitWheelHistory(id:int):void
		{
		}
	}
}