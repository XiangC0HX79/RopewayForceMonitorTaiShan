package app.model
{
	import app.model.vo.ParamVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ParamProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ParamProxy";
		
		public function ParamProxy()
		{
			super(NAME, new ParamVO);
		}
		
		public function get param():ParamVO
		{
			return data as ParamVO;
		}
	}
}