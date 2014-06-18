package forceMonitor.view
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
	
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.model.ConfigProxy;
	import forceMonitor.model.RopewayAlarmAnalysisProxy;
	import forceMonitor.model.RopewayForceAverageProxy;
	import forceMonitor.model.RopewayProxy;
	import forceMonitor.model.WebServiceProxy;
	import forceMonitor.model.vo.ConfigVO;
	import forceMonitor.model.vo.RopewayAlarmVO;
	import forceMonitor.model.vo.RopewayVO;
	import forceMonitor.view.components.PanelAnalysisAlarm;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelAnalysisAlarmMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisAlarmMediator";
		
		private var _ropewayAlarmAnalysisProxy:RopewayAlarmAnalysisProxy;
		
		public function PanelAnalysisAlarmMediator()
		{
			super(NAME,new PanelAnalysisAlarm);
			
			panelAnalysisAlarm.addEventListener(PanelAnalysisAlarm.QUERY,onQuery);
			panelAnalysisAlarm.addEventListener(PanelAnalysisAlarm.STATION_CHANGE,onStationChange);
			
			panelAnalysisAlarm.addEventListener(PanelAnalysisAlarm.EXPORT,onExport);
		}
		
		override public function onRegister():void
		{												
			_ropewayAlarmAnalysisProxy = facade.retrieveProxy(RopewayAlarmAnalysisProxy.NAME) as RopewayAlarmAnalysisProxy;
			panelAnalysisAlarm.colRopewayHis = _ropewayAlarmAnalysisProxy.colAlarm;
		}		
		
		protected function get panelAnalysisAlarm():PanelAnalysisAlarm
		{
			return viewComponent as PanelAnalysisAlarm;
		}
		
		private function onStationChange(event:Event):void
		{			
			var station:String = String(panelAnalysisAlarm.rbgStation.selectedValue);
			changeStation(station);
		}
		
		private function onGetRopewayList(event:ResultEvent,t:Object):void
		{
			var arr:Array = [RopewayVO.ALL];
			for each(var o:ObjectProxy in event.result)
			{
				var rw:RopewayVO = new RopewayVO(o);
				arr.push(rw);
			}
			panelAnalysisAlarm.colRopeway = new ArrayCollection(arr);
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisAlarm.dateE.time < panelAnalysisAlarm.dateS.time)
			{
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}			
			var token:AsyncToken = _ropewayAlarmAnalysisProxy.GetAlarmCol(
				panelAnalysisAlarm.dateS
				,panelAnalysisAlarm.dateE
				,String(panelAnalysisAlarm.rbgStation.selectedValue)
				,panelAnalysisAlarm.listRopewayId.selectedItem.ropewayId
			);;
		}	
		
		private function changeStation(station:String):void
		{
			var arr:Array = [];
			if(station != "所有索道站")
			{
				var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
				for each(var r:RopewayVO in proxy.colRopeway)
				{
					if(r.ropewayStation == station)
					{
						arr.push(r);
					}
				}
			}
			
			arr.sortOn("ropewayCarId");
			
			arr.unshift(RopewayVO.ALL);
			
			panelAnalysisAlarm.colRopeway.source = arr;
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
				sendNotification(ForceMonitorFacade.NOTIFY_MAIN_LOADING_SHOW,"正在下载《" + xltname + "》...");				
			}
			
			function onDownloadFile(event:Event):void 
			{							
				sendNotification(ForceMonitorFacade.NOTIFY_MAIN_LOADING_HIDE);	
				
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_INFO,"《" + xltname + "》下载成功。");	
			}		
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			sendNotification(ForceMonitorFacade.NOTIFY_MAIN_LOADING_HIDE);
			
			sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ERROR,event.text);
		}	
		
		override public function listNotificationInterests():Array
		{
			return [
				ForceMonitorFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForceMonitorFacade.NOTIFY_INIT_APP_COMPLETE:
					var proxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					
					panelAnalysisAlarm.colStations = proxy.config.stations;	
					
					panelAnalysisAlarm.colRopeway.source = [RopewayVO.ALL];
					
					panelAnalysisAlarm.rbgStation.selectedValue = proxy.config.stations[0];
					
					changeStation(proxy.config.stations[0]);
					break;
			}
		}
	}
}