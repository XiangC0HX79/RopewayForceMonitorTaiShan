package app.model
{
	import app.ApplicationFacade;
	
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
			webService.loadWSDL(BASE_URL + "Service.asmx?wsdl");
			
			var operation:Operation = webService.getOperation(name) as Operation;
			operation.addEventListener(ResultEvent.RESULT,listener);
			operation.addEventListener(FaultEvent.FAULT,onFault);
			operation.arguments = args;
			operation.resultFormat = "object";
			
			return operation.send();
		}
		
		private function onResult(event:ResultEvent):void
		{	
			if(event.result == null)
				return;
			
			if(event.result is ObjectProxy)
			{
				if(event.result.hasOwnProperty("Tables"))
				{
					var tables:Object = event.result.Tables;
					if(tables.hasOwnProperty("Table"))
					{
						event.token.listener(tables.Table.Rows);
					}
					if(tables.hasOwnProperty("Count"))
					{
						event.token.listener(tables.Count.Rows[0].Count);
					}
					else if(tables.hasOwnProperty("Error"))
					{	
						sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,"后台服务错误" + "\n" + tables.Error.Rows[0]["ErrorInfo"]);
					}
				}
				else
				{
					event.token.listener(event.result);
				}
			}
			else
			{
				event.token.listener(event.result);
			}
		}
		
		private function onFault(event:FaultEvent):void
		{	
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,event.fault.faultString + "\n" + event.fault.faultDetail);
		}
		
	}
}