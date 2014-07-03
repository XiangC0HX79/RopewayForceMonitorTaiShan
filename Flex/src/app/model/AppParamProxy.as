package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.AppParamVO;
	import app.model.vo.InternalVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	use namespace InternalVO; 
	
	public class AppParamProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String = "AppParamProxy";
		public static const SRNAME:String = "AppParamProxySR";
		
		public static const LOADED:String = "AppParamProxy/Loaded";
		public static const FAILED:String = "AppParamProxy/Failed";
		
		public function AppParamProxy()
		{
			super(NAME, new AppParamVO);
		}
		
		public function get appParam():AppParamVO
		{
			return data as AppParamVO;
		}
		
		public function load():void
		{
			appParam.selRopeway = RopewayVO.getNamed(RopewayVO.ZHONG_TIAN_MEN);
			
			sendNotification(LOADED,NAME);
			
			sendNotification(ApplicationFacade.ACTION_UPDATE_APP_PARAM,appParam);
		}		
		
		public function getCurrentRopeway():RopewayVO
		{
			return appParam.selRopeway;
		}
	}
}