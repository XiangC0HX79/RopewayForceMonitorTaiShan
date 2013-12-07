package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.ConfigVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ConfigProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "ConfigProxy";
		
		public function ConfigProxy()
		{
			super(NAME, new ConfigVO);
		}
		
		public function get config():ConfigVO
		{
			return data as ConfigVO;
		}
		
		public function InitConfig(ds:String):void
		{
			var load:URLLoader = new URLLoader(new URLRequest("config.xml"));			
			load.addEventListener(Event.COMPLETE,onLocaleConfigResult);
			load.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
						
			function onLocaleConfigResult(event:Event):void
			{				
				try
				{
					var xml:XML = new XML(event.currentTarget.data);
				}
				catch(e:Object)
				{
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,"配置文件损坏，请检查config.xml文件正确性！");
					return;
				}
				
				config.stations = new Array;
				config.stationsid = new Array;
				
				for each(var s:String in xml.Stations.Station)
				{
					var arr:Array = s.split("/");
					for each(var strid:String in ds.split(","))
					{
						if(strid == arr[1])
						{
							config.stations.push(arr[0]);
							config.stationsid.push(arr[1]);
						}
					}
				}
				//FlexGlobals.topLevelApplication.Config = config;
				
				WebServiceProxy.BASE_URL = xml.WebServiceUrl;	
				
				sendNotification(ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,config);
			}
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,event.text);
		}
	}
}