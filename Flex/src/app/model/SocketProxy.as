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
	import app.model.vo.SurroundingTempVO;
	import app.model.vo.WindValueVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.flex.config.model.ConfigProxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	public class SocketProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String = "SocketProxy";
		public static const SRNAME:String = "SocketProxySR";
		
		private var _errorCount:Number = 0;
		
		private var _socket:Socket;
		
		private var _serverIp:String;
		
		private var _serverPort:Number;
		
		public function SocketProxy()
		{
			super(NAME);
		}
		
		public function load():void
		{			
			if(_socket)
			{
				sendNotification(ApplicationFacade.NOTIFY_SOCKET_LOADED,NAME);
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
			
			_errorCount ++;
			
			trace("ErrorCount:" + _errorCount);
		}
		
		private function onConnect( event:Event ):void 
		{  													
			_errorCount = 0;	
			
			sendNotification(ApplicationFacade.NOTIFY_SOCKET_LOADED,NAME);
		}  
		
		private function onConnectError(event:Event):void 
		{  			
			if(_errorCount > 5)
			{
				sendNotification(ApplicationFacade.NOTIFY_SOCKET_FAILED,NAME);
				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,"服务器连接失败，无法接收实时数据，请检查网络！按F5刷新页面开始重连服务器。\n\"错误原因:" + event.type + "\"");
			}
			else
				load();
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
				
				var rw:RopewayVO = new RopewayVO(a[2]);
				var rs:RopewayStationVO = new RopewayStationVO(a[3]);
				
				switch(a[0])
				{	
					//case "FC":
					//	decodeRopewayForce(a.slice(1));
					//	break;
					
					case "ET":
						var st:SurroundingTempVO = new SurroundingTempVO;
						st.ropewayStation = rs;
						st.date = dt;
						st.temp = Number(a[4]);
						st.humi = Number(a[5]);
						
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_SURROUDING_TEMP,st);
						break;
					
					case "TE":
						var et:EngineTempVO = new EngineTempVO;
						et.date = dt;
						et.temp = Number(a[5]);
						
						var pos:int = int(a[4]);
						
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_ENGINE_TEMP,[rw,pos,et]);
						break;
					
					case "ZJ":
						var inch:InchValueVO = new InchValueVO;
						inch.date = dt;
						inch.temp = Number(a[4]);
						inch.humi = Number(a[5]);
						inch.value = Number(a[6]);
						
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_INCH,[rw,inch]);
						break;		
					
					case "FS":
						var wind:WindValueVO = new WindValueVO;
						wind.date = dt;
						wind.speed = Number(a[5]);
						wind.dir = Number(a[6]);
						
						var bracketId:Number = Number(a[4]);
						
						sendNotification(ApplicationFacade.NOTIFY_SOCKET_WIND,[new BracketVO(bracketId,rw),wind]);
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