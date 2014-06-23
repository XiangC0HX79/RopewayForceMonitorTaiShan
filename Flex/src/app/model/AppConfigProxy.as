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
			
			sendNotification(ApplicationFacade.NOTIFY_CONFIG_FAILED,ConfigProxy.NAME);
		}
		
		override public function result(event:Object):void
		{
			super.result(event);
			
			sendNotification(ApplicationFacade.NOTIFY_CONFIG_LOADED,ConfigProxy.NAME);
		}
				
		public function load():void
		{
			retrieveConfig();
		}
	}
} 