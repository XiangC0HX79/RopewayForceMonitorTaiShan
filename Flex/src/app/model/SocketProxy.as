package app.model
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	import app.ApplicationFacade;
	import app.model.vo.AppConfigVO;
	import app.model.vo.BracketVO;
	import app.model.vo.EngineTempVO;
	import app.model.vo.InchValueVO;
	import app.model.vo.RopewayStationVO;
	import app.model.vo.RopewayVO;
	import app.model.vo.SurroundingVO;
	import app.model.vo.WindValueVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.flex.config.model.ConfigProxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	public class SocketProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String = "SocketProxy";
		public static const SRNAME:String = "SocketProxySR";
		
		public static const LOADED:String = "SocketProxy/Loaded";
		public static const FAILED:String = "SocketProxy/Failed";
		
		private var _errorCount:Number = 0;
		
		private var _socket:Socket;
		
		private var _serverIp:String;
		
		private var _serverPort:Number;
		
		private var _Loaded:Boolean = false;
		
		public function SocketProxy()
		{
			super(NAME);
		}
		
		public function load():void
		{			
			if(_socket)
			{
				sendNotification(LOADED,NAME);
				return;
			}
			
			_socket = new Socket;
			_socket.addEventListener(Event.CONNECT,onConnect);				
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,onSocketData);  			
			_socket.addEventListener(Event.CLOSE,onConnectError);		
			_socket.addEventListener(IOErrorEvent.IO_ERROR,onConnectError);			
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onConnectError);
			
			var appConfigProxy:AppConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as AppConfigProxy;
			_serverIp = AppConfigVO(appConfigProxy.configVO).socketIp;
			_serverPort = Number(AppConfigVO(appConfigProxy.configVO).socketPort);
			
			_socket.connect(_serverIp,_serverPort);
			
			Security.loadPolicyFile("xmlsocket://" + _serverIp + ":" + _serverPort);
		}
				
		private function connect():void
		{
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW,"正在连接服务器...");
			
			_socket.connect(_serverIp,_serverPort);
			
			Security.loadPolicyFile("xmlsocket://" + _serverIp + ":" + _serverPort);
			
			_errorCount ++;
			
			//trace("ErrorCount:" + _errorCount);
		}
		
		private function onConnect( event:Event ):void 
		{  													
			_errorCount = 0;	
			
			if(_Loaded)
			{
				sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);				
			}
			else
			{
				_Loaded = true;
				sendNotification(LOADED,NAME);
			}
		}  
		
		private function onConnectError(event:Event):void 
		{  			
			if(_errorCount > 5)
			{
				//sendNotification(FAILED,NAME);
				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,"服务器连接失败，无法接收实时数据，请检查网络！按F5刷新页面开始重连服务器。\n\"错误原因:" + event.type + "\"");
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
		
		private function getDataArray(socketData:ByteArray):Array
		{			
			//var d:String = ;
			
			//trace(d);
			
			var reg:RegExp = /&{2}.*?@{2}/g;
			
			return socketData.readMultiByte(socketData.length,"gb2312").match(reg);
		}
		
		private function decodeSocketData(socketData:ByteArray):void
		{			
			/*var d:String = socketData.readMultiByte(socketData.length,"gb2312");
			
			trace(d);
			
			var reg:RegExp = /&{2}.*?@{2}/g;
			var colS:Array = d.match(reg);*/
						
			for each(var s:String in getDataArray(socketData))
			{				
				//var content:String = ;
				
				//if(content == "")
				//	continue;
				
				var a:Array = s.substr(2,s.length - 4).split('|');
				
				var sd:String = String(a[1]).replace(/-/g,"/");
				var dt:Date = new Date(Date.parse(sd));
				
				//var rw:RopewayVO = RopewayVO.getNamed(a[2]);
				//var rs:RopewayStationVO = RopewayStationVO.getNamed(a[3]);
				
				switch(a[0])
				{	
					//case "FC":
					//	decodeRopewayForce(a.slice(1));
					//	break;
					
					case "ET":						
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_SURROUDING,a);
						break;
					
					case "TE":						
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_ENGINE,a);
						break;
					
					case "ZJ":
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_INCH,a);
						break;		
					
					case "FS":
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_WIND,a);
						break;			
					
					case "YL":
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_PRESS,a);
						break;					
					
					case "AL":
						/*	var rs:RopewayStationVO = new RopewayStationVO(a[1]);
						if(rs)
						{
						sendNotification(ApplicationFacade.NOTIFY_ROPEWAY_ALARM_REALTIME,rs);
						}*/
						break;
				}
			}
		}
	}
}