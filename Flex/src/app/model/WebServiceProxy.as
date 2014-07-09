package app.model
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;
	
	import app.ApplicationFacade;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class WebServiceProxy extends Proxy implements IProxy
	{
		private static var _webService:WebService;
		
		public static function factoryCreate(wsdl:String):void
		{
			_webService = new WebService;
			_webService.loadWSDL(wsdl);
		}
		
		public function WebServiceProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		protected function send(name:String,...args):AsyncToken
		{							
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW,"正在读取数据...");
									
			var operation:Operation = _webService.getOperation(name) as Operation;
			operation.arguments = args;
			operation.addEventListener(FaultEvent.FAULT,onFault);
			operation.resultFormat = "object";
			
			var token:AsyncToken = operation.send();
			token.addResponder(new AsyncResponder(onResult,function (event:FaultEvent,t:Object):void{}));
			
			return token;
		}
		
		private function onResult(event:ResultEvent,t:Object):void
		{							
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);			
		}		
		
		protected function sendNoBusy(name:String,...args):AsyncToken
		{									
			var operation:Operation = _webService.getOperation(name) as Operation;
			operation.arguments = args;
			operation.addEventListener(FaultEvent.FAULT,onFault);
			operation.resultFormat = "object";
			
			var token:AsyncToken = operation.send();
			//token.addResponder(new AsyncResponder(onResultNoBusy,function (event:FaultEvent,t:Object):void{},listener));
			
			return token;
		}
		
		private function onFault(event:FaultEvent):void
		{	
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);
			
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,event.fault.faultString + "\n" + event.fault.faultDetail);
		}	
		
		public function export(name:String,fileName:String,urlVar:URLVariables):void
		{
			var baseUrl:String = _webService.wsdl;
			var url:String = encodeURI(baseUrl.substr(0,baseUrl.lastIndexOf("/") + 1) + name + ".aspx");
						
			var downloadURL:URLRequest = new URLRequest(encodeURI(url));				
			downloadURL.method = URLRequestMethod.POST;
			downloadURL.contentType = "text/plain";	
			downloadURL.data = urlVar;
			
			var fileRef:FileReference = new FileReference;
			fileRef.addEventListener(Event.SELECT,onFileSelect);				
			fileRef.addEventListener(Event.COMPLETE,onDownloadFile);
			fileRef.addEventListener(IOErrorEvent.IO_ERROR,onIOError);			
			fileRef.download(downloadURL,fileName);	
		}
		
		private function onFileSelect(event:Event):void
		{						
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW,"正在下载《" + event.currentTarget.name + "》...");				
		}
		
		private function onDownloadFile(event:Event):void 
		{							
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);	
			
			sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"《" + event.currentTarget.name + "》下载成功。");	
		}		
		
		private function onIOError(event:IOErrorEvent):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);
			
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,event.text);
		}	
	}
}