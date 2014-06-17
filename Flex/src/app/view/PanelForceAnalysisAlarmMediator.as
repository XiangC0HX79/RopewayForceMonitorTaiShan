package app.view
{
	import com.adobe.serialization.json.JSON;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.graphics.codec.JPEGEncoder;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import app.ApplicationFacade;
	import app.model.CarriageProxy;
	import app.model.ConfigProxy;
	import app.model.RopewayAlarmAnalysisProxy;
	import app.model.WebServiceProxy;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.CarriageVO;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayAlarmVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.PanelForceAnalysisAlarm;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelForceAnalysisAlarmMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelForceAnalysisAlarmMediator";
		
		private var _ropewayAlarmAnalysisProxy:RopewayAlarmAnalysisProxy;
		
		public function PanelForceAnalysisAlarmMediator()
		{
			super(NAME,new PanelForceAnalysisAlarm);
			
			panelAnalysisAlarm.addEventListener(PanelForceAnalysisAlarm.QUERY,onQuery);
			panelAnalysisAlarm.addEventListener(PanelForceAnalysisAlarm.STATION_CHANGE,onStationChange);
			
			panelAnalysisAlarm.addEventListener(PanelForceAnalysisAlarm.EXPORT,onExport);
			
			_ropewayAlarmAnalysisProxy = facade.retrieveProxy(RopewayAlarmAnalysisProxy.NAME) as RopewayAlarmAnalysisProxy;
			panelAnalysisAlarm.colRopewayHis = _ropewayAlarmAnalysisProxy.colAlarm;
		}
		
		protected function get panelAnalysisAlarm():PanelForceAnalysisAlarm
		{
			return viewComponent as PanelForceAnalysisAlarm;
		}
		
		private function onStationChange(event:Event):void
		{			
			changeStation();
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisAlarm.dateE.time < panelAnalysisAlarm.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}			
			var token:AsyncToken = _ropewayAlarmAnalysisProxy.GetAlarmCol(
				panelAnalysisAlarm.dateS
				,panelAnalysisAlarm.dateE
				,panelAnalysisAlarm.selStation.fullName
				,panelAnalysisAlarm.listRopewayId.selectedItem.ropewayId
			);;
		}	
		
		private function changeStation():void
		{
			var carriageProxy:CarriageProxy = facade.retrieveProxy(CarriageProxy.NAME) as CarriageProxy;
			
			panelAnalysisAlarm.colCarriage = carriageProxy.GetCarriageWithForceAll(panelAnalysisAlarm.selStation);
		}	
				
		private const xltname:String = "报警信息";	
		
		private function onExport(event:Event):void
		{			
			var baseUrl:String = WebServiceProxy.BASE_URL;
			var url:String = encodeURI(baseUrl.substr(0,baseUrl.lastIndexOf("/")) + "/ExportChart.aspx");
			
			var urlVar:URLVariables = new URLVariables;
			urlVar.xltname = xltname;
			
			var data:String = "[";
			for each(var rf:RopewayAlarmVO in panelAnalysisAlarm.colRopewayHis)
			{
				data += rf.toString() + ",";
			}
			data = data.substr(0,data.length - 1) + "]";
			urlVar.data = data;
						
			var downloadURL:URLRequest = new URLRequest(encodeURI(url));				
			downloadURL.method = URLRequestMethod.POST;
			downloadURL.contentType = "text/plain";	
			downloadURL.data = urlVar;
			
			var fileRef:FileReference = new FileReference;
			fileRef.addEventListener(Event.SELECT,onFileSelect);				
			fileRef.addEventListener(Event.COMPLETE,onDownloadFile);
			fileRef.addEventListener(IOErrorEvent.IO_ERROR,onIOError);			
			fileRef.download(downloadURL,xltname + ".xls");	
			
			function onFileSelect(event:Event):void
			{						
				sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW,"正在下载《" + xltname + "》...");				
			}
			
			function onDownloadFile(event:Event):void 
			{							
				sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);	
				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,"《" + xltname + "》下载成功。");	
			}		
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);
			
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,event.text);
		}	
		
		override public function listNotificationInterests():Array
		{
			return [
				//ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					panelAnalysisAlarm.colStations = RopewayStationDict.list;	
					
					panelAnalysisAlarm.selStation = panelAnalysisAlarm.colStations[0];
					
					changeStation();
					break;
			}
		}
	}
}