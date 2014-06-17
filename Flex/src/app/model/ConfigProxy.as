package app.model
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	
	import app.ApplicationFacade;
	import app.model.dict.RopewayDict;
	import app.model.vo.ConfigVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ConfigProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "ConfigProxy";
		
		public function ConfigProxy()
		{
			super(NAME, new ConfigVO);
			
			config.ropeway = RopewayDict.list[0];
		}
		
		public function get config():ConfigVO
		{
			return data as ConfigVO;
		}
		
		public function InitConfig(resultHandle:Function):void
		{			
			var load:URLLoader = new URLLoader(new URLRequest("config.xml"));		
			
			load.addEventListener(Event.COMPLETE,onLocaleConfigResult);		
			load.addEventListener(Event.COMPLETE,resultHandle);
			
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
			config.serverIp = xml.ServerIp;
			
			config.serverPort = int(xml.ServerPort);	
						
			WebServiceProxy.BASE_URL = xml.WebServiceUrl;
		}
	}
}