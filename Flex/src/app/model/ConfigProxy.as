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
			
			var index:Number = Number(config.station);
			if(!isNaN(index))
			{
				if(index == 0)
				{
					config.stations = new ArrayCollection(col);
				}
				else if((index <= col.length) && (index > 0))
				{
					config.stations = new ArrayCollection([col[index - 1]]);
				}
				else
				{
					config.stations = new ArrayCollection(col[0]);
				}
			}
			else
			{
				config.stations = new ArrayCollection(col[0]);
			}
			
			/*var value:Number = Number(xml.AlarmValue);
			if(!isNaN(value))
			{
				RopewayProxy.alarmVal = value;
			}*/
			
			config.station = config.stations[0];
					
			config.serverIp = xml.ServerIp;
			
			config.serverPort = int(xml.ServerPort);	
						
			WebServiceProxy.BASE_URL = xml.WebServiceUrl;
				
			sendNotification(ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,config);
		}
	}
}