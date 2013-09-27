package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.ConfigVO;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ConfigProxy extends WebServiceProxy implements IProxy
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
		
		public function InitConfig(station:String):void
		{			
			config.station = station;
			
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
			
			var col:Array = [];
			RopewayProxy.dictAlarmValue = new Dictionary;
			for each(var x:XML in xml.Stations.Station)
			{
				var s:String = String(x.SName);
				col.push(s);
				RopewayProxy.dictAlarmValue[s] = Number(x.AlarmValue);
			}
			config.stations = new ArrayCollection(col);
								
			config.serverIp = xml.ServerIp;
			
			config.serverPort = int(xml.ServerPort);	
						
			WebServiceProxy.BASE_URL = xml.WebServiceUrl;
							
			send("RopeDete_InitDept",onInitDept,config.station);
		}
		
		private function onInitDept(event:ResultEvent):void
		{
			var col:Array = [];
			for each(var s:String in config.stations)
			{
				for each(var item:Object in event.result)
				{
					if(s.indexOf(String(item.DWMC))>=0)
					{
						col.push(s);
						break;
					}
				}				
			}
			config.stations.source = col;
			
			config.station = config.stations[0];
						
			sendNotification(ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,config);
		}
	}
}