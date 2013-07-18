package app.model
{
	import app.ApplicationFacade;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.soap.Operation;
	import mx.rpc.soap.WebService;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class WebServiceProxy extends Proxy implements IProxy
	{
		public static var BASE_URL:String;
		
		public function WebServiceProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		protected function send(name:String,listener:Function,...args):AsyncToken
		{				
			var webService:WebService = new WebService;
			webService.loadWSDL(BASE_URL);
			
			var operation:Operation = webService.getOperation(name) as Operation;
			operation.arguments = args;
			operation.addEventListener(FaultEvent.FAULT,onFault);
			operation.resultFormat = "object";
			
			var token:AsyncToken = operation.send();
			token.addResponder(new AsyncResponder(onResult,function (event:FaultEvent,t:Object):void{},listener));
			
			return token;
		}
				
		private function onFault(event:FaultEvent):void
		{	
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);
			
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,event.fault.faultString + "\n" + event.fault.faultDetail);
		}	
		
		private function onResult(event:ResultEvent,listener:Function):void
		{				
			if(listener != null)
				listener(event);
		}		
	}
}