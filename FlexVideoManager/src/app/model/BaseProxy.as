package app.model
{
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.http.HTTPService;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class BaseProxy extends Proxy implements IProxy
	{
		public function BaseProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
		
		protected function send(operatorName:String,parameters:Object,resultFunction:Function):AsyncToken
		{
			var rootURL:String = "";
			
			IFDEF::Debug
			{
				rootURL = "http://localhost:6361/VideoManager/";
			}
									
			var http:HTTPService = new HTTPService;
			http.url = rootURL + operatorName + ".aspx";
			http.addEventListener(FaultEvent.FAULT,onFault);
			
			var token:AsyncToken = http.send(parameters);
			token.addResponder(new AsyncResponder(resultFunction,function(error:FaultEvent,token:Object):void{}));
			return token;
			
			function onFault(event:FaultEvent):void
			{
				sendNotification(Notifications.NOTIFY_ALERT_ERROR,"方法：" + operatorName + "\n" + event.fault.faultString + "\n" + event.fault.faultDetail);
			}
		}
	}
}