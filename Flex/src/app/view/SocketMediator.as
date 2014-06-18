package app.view
{
	import com.adobe.utils.DateUtil;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import app.ApplicationFacade;
	import app.model.EngineTempProxy;
	import app.model.InchProxy;
	import app.model.dict.RopewayDict;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.ConfigVO;
	import app.model.vo.EngineTempVO;
	import app.model.vo.EngineVO;
	import app.model.vo.InchValueVO;
	import app.model.vo.SurroundingTempVO;
	
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
		}
		
		protected function get socket():Socket
		{
			return viewComponent as Socket;
		}
				
		private function connect():void
		{
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW,"正在连接服务器...");
			
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
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,"服务器连接失败，无法接收实时数据，请检查网络！按F5刷新页面开始重连服务器。\n\"错误原因:" + event.type + "\"");
								
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
			
			decodeSocketData(bytesArray);
			
			bytesArray= new ByteArray;
		}  
		
		private function decodeSocketData(socketData:ByteArray):void
		{			
			var d:String = socketData.readMultiByte(socketData.length,"gb2312");
			
			trace(d);
			
			var reg:RegExp = /&{2}.*?@{2}/g;
			var colS:Array = d.match(reg);
			
			//var colS:Array = d.split("@");
			
			for each(var s:String in colS)
			{				
				var content:String = s.substr(2,s.length - 4);
				
				if(content == "")
					continue;
				
				var a:Array = content.split('|');
				
				var sd:String = String(a[1]).replace(/-/g,"/");
				var dt:Date = new Date(Date.parse(sd));
				
				var ropeway:RopewayDict = RopewayDict.dict[a[2]];
				var ropewayStation:RopewayStationDict = RopewayStationDict.dict[a[3]];
				
				switch(a[0])
				{	
					//case "FC":
					//	decodeRopewayForce(a.slice(1));
					//	break;
					
					case "ET":
						var st:SurroundingTempVO = new SurroundingTempVO;
						st.date = dt;
						st.temp = Number(a[4]);
						st.humi = Number(a[5]);
						
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_SURROUDING_TEMP,[ropewayStation,st]);
						break;
					
					case "TE":
						var et:EngineTempVO = new EngineTempVO;
						et.date = dt;
						et.temp = Number(a[5]);
						
						var pos:int = int(a[4]);
						
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_ENGINE_TEMP,[ropeway,pos,et]);
						break;
					
					case "ZJ":
						var inch:InchValueVO = new InchValueVO;
						inch.date = dt;
						inch.temp = Number(a[4]);
						inch.humi = Number(a[5]);
						inch.value = Number(a[6]);
						
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_INCH,[ropeway,inch]);
						break;						
					
					case "AL":
						var rs:RopewayStationDict = RopewayStationDict.dict[a[1]];
						if(rs)
						{
							sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_ALARM_REALTIME,rs);
						}
						break;
				}
			}
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
				
				ApplicationFacade.NOTIFY_ROPEWAY_INFO_SET,
				
				ApplicationFacade.NOTIFY_SOCKET_KEEP
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:		
					_config = notification.getBody() as ConfigVO;
					connect();
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_SET:
					sendSocketData("RFID");
					break;
				
				case ApplicationFacade.NOTIFY_SOCKET_KEEP:
					sendSocketData("KEEP");
					break;
			}
		}
	}
}