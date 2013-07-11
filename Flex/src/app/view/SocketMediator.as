package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayAlarmProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	
	import com.adobe.utils.DateUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class SocketMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "SocketMediator";
		
		private var _errorCount:Number = 0;
		
		private var _config:ConfigVO;
		
		public function SocketMediator()
		{
			super(NAME, new Socket);			
			
			socket.addEventListener(Event.CONNECT,onConnect);				
			socket.addEventListener(ProgressEvent.SOCKET_DATA,onSocketData);  			
			socket.addEventListener(Event.CLOSE,onConnectError);		
			socket.addEventListener(IOErrorEvent.IO_ERROR,onConnectError);			
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onConnectError);
						
			var timer:Timer = new Timer(30000);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
		}
		
		protected function get socket():Socket
		{
			return viewComponent as Socket;
		}
				
		private function connect():void
		{
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW,"正在连接服务�..");
				
			socket.connect(_config.serverIp,_config.serverPort);
				
			Security.loadPolicyFile("xmlsocket://" + _config.serverIp + ":" + _config.serverPort);
			
			_errorCount ++;
			
			trace("ErrorCount:" + _errorCount);
		}
		
		private function onConnect( event:Event ):void 
		{  													
			_errorCount = 0;	
			
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);
		}  
		
		private function onConnectError(event:Event):void 
		{  			
			if(_errorCount > 5)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,"服务器连接失败，无法接收实时数据，请检查网络！\n\"错误原因:" + event.type + "\"");
								
				sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);
			}
			else
				connect();
		} 
		
		//接受数据		
		private var bytesArray:ByteArray = new ByteArray;
		private function onSocketData(event:ProgressEvent):void 
		{  			
			var target:Socket = event.target as Socket;
			
			while(target.bytesAvailable)			
			{			
				target.readBytes(bytesArray,bytesArray.length);
				
				//如出现Error: Error #2030: 遇到文件尾错误，请用：str=socket.readUTFBytes(socket.bytesAvailable);				
			}
			
			if(!_rec)
			{
				_rec = true;
				
				decodeSocketData(bytesArray);
			}
			
			bytesArray= new ByteArray;
		}  
		
		private function decodeSocketData(socketData:ByteArray):void
		{			
			var s:String = socketData.readMultiByte(socketData.length,"gb2312");
			var a:Array = s.split('|');
			
			var rf:RopewayForceVO = new RopewayForceVO(new ObjectProxy({}));
			rf.ropewayId = "T000" + Math.ceil(Math.random() * 2); //a[1];		
			rf.ropewayForce = Number(a[2]);
			rf.ropewayUnit = a[3];
			rf.ropewayTemp = a[4];
			var sd:String = String(a[0]).replace(/-/g,"/");
			rf.ropewayTime = new Date(Date.parse(sd));
			
			var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			var rw:RopewayVO = proxy.ropewayDict[rf.ropewayId];
		
			if(rw)
			{			
				rw.lastRopewayForce = rf;
				
				if(rw.ropewayStation == _config.station)
					sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME,rw);
			}
			else
			{
				var token:AsyncToken = proxy.AddRopeway(rf);
				token.ropewayForce = rf;
				token.addResponder(new AsyncResponder(onAddRopewayResult,function(error:FaultEvent,token:Object = null):void{},token));
			}
		}
		
		private function onAddRopewayResult(event:ResultEvent,token:Object = null):void
		{
			var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
						
			if(event.result)
			{
				var rw:RopewayVO = new RopewayVO(event.result as ObjectProxy);
				
				proxy.ropewayDict[rw.ropewayId] = rw;
				
				rw.lastRopewayForce = token.ropewayForce;
				
				if(rw.ropewayStation == _config.station)
					sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME,rw);
			}
		}
		
		private var _rec:Boolean = false;
		
		private var _oldTime:Date = new Date;
		
		private function onTimer(event:Event):void
		{			
			_rec = false;
			
			var now:Date = new Date;
			
			if(_oldTime.toLocaleDateString() != now.toLocaleDateString())
			{
				var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
				for each(var r:RopewayVO in proxy.ropewayDict)
				{
					r.ropewayHistory = [];
				}
			}
							
			_oldTime = now;
			
			sendSocketData("KEEP");
		}
		
		private function sendSocketData(socketData:String):void
		{
			if(socket.connected)
			{				
				socket.writeUTFBytes(socketData);				
				socket.flush();
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,
				
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					_config = notification.getBody() as ConfigVO;
					break;
				
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					connect();
					break;
			}
		}
	}
}