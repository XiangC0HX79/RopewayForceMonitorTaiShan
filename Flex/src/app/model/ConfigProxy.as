package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.ConfigVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	
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
		
		public function InitConfig(unit:String):void
		{
			config.station = unit;
			
			var load:URLLoader = new URLLoader(new URLRequest("config.xml"));			
			load.addEventListener(Event.COMPLETE,onLocaleConfigResult);
			load.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,event.text);
		}
		
		private function onLocaleConfigResult(event:Event):void
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
			
			config.stations = new ArrayCollection;
			for each(var s:String in xml.Stations.Station)
				config.stations.addItem(s);
							
			config.station = config.stations[0];
					
			config.serverIp = xml.ServerIp;
			
			config.serverPort = int(xml.ServerPort);	
			
			ConfigVO.debug = Boolean(Number(xml.Debug));
			
			WebServiceProxy.BASE_URL = xml.WebServiceUrl;
				
			sendNotification(ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,config);
		}
	}
}