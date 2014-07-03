package app.model
{
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
		
		/*private function onResultNoBusy(event:ResultEvent,listener:Function):void
		{				
			if(listener != null)
				listener(event);	
		}		*/
	}
}