package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.AppConfigVO;
	
	import org.puremvc.as3.multicore.utilities.flex.config.interfaces.IConfigVO;
	import org.puremvc.as3.multicore.utilities.flex.config.model.ConfigProxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;

	public class AppConfigProxy extends ConfigProxy implements ILoadupProxy
	{	
		//public static const NAME:String = "AppConfigProxy";
		public static const SRNAME:String = "AppConfigProxySR";
		
		public static const LOADED:String = "AppConfigProxy/Loaded";
		public static const FAILED:String = "AppConfigProxy/Failed";
				
		public function AppConfigProxy(configURL:String)
		{
			super(configURL);
		}
		
		override protected function constructVO():IConfigVO
		{
			return new AppConfigVO();
		}
		
		override public function fault(event:Object):void
		{
			super.fault(event);
			
			sendNotification(FAILED,ConfigProxy.NAME);
		}
		
		override public function result(event:Object):void
		{
			super.result(event);
			
			WebServiceProxy.factoryCreate(AppConfigVO(configVO).webserviceInfo);
			
			sendNotification(LOADED,ConfigProxy.NAME);
		}
				
		public function load():void
		{
			retrieveConfig();
		}
	}
} 