package app.model
{
	import app.model.vo.AppParamVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class AppParamProxy extends Proxy
	{
		public static const NAME:String = "AppParamProxy";
		
		public function AppParamProxy()
		{
			super(NAME, new AppParamVO);
		}
		
		public function get appParam():AppParamVO
		{
			return data as AppParamVO;
		}
		
		override public function onRegister():void
		{
			appParam.selRopeway = RopewayVO.ZHONG_TIAN_MEN;
		}
		
		public function updateRopeway(rw:RopewayVO):void
		{
			appParam.selRopeway = rw;
		}
	}
}