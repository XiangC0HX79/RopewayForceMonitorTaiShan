package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayAlarmAnalysisProxy;
	import app.model.RopewayProxy;
	import app.model.WebServiceProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayAlarmVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelAnalysisAlarm;
	
	import com.adobe.serialization.json.JSON;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.graphics.codec.JPEGEncoder;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
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
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
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
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW,"正在导出数据，请稍后..");
			
			flash.utils.setTimeout(export,200);
		}	
		
		private function export():void
		{
			var bound:String = "---------------------------293342587424372"; //暂时固定，留待扩充
			var cntType: String = "multipart/form-data;boundary=" + bound;
			var header:URLRequestHeader = new URLRequestHeader ("Content-Type", cntType);
			
			var data:ByteArray = new ByteArray(); //用于保存URLRequest体内容的数组
			
			//开始封装图表内容					
			var ts:String = "--" + bound + "\r\n" + "Content-Disposition: form-data; name=\"table\"; filename=\"table.xls\";\r\n";
			ts += "Content-Type: image/jpg\r\n\r\n";
			
			data.writeMultiByte(ts, "GB2312");
			
			data.position = data.length;
			var json:String = "[";
			for each(var rf:RopewayAlarmVO in panelAnalysisAlarm.colRopewayHis)
			{
				json += rf.toString() + ",";
			}
			json = json.substr(0,json.length - 1) + "]";
			data.writeMultiByte(json, "GB2312");
			
			//添加结束分隔符					
			var es:String = "\r\n--" + bound + "--\r\n";
			
			data.position = data.length;
			data.writeMultiByte(es, "GB2312");
			
			var baseUrl:String = WebServiceProxy.BASE_URL;
			var url:String = encodeURI(baseUrl.substr(0,baseUrl.lastIndexOf("/")) + "/ExportChart.aspx?xltname=" + xltname);
			var request:URLRequest = new URLRequest(url);
			request.requestHeaders.push(header);
			request.method = "POST";	
			request.data = data; //添加为URLRequest的体内容
			
			var load:URLLoader = new URLLoader(request);
			load.addEventListener(Event.COMPLETE, onUpload);
			load.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
		}
		
		private function onUpload(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);
			
			var jd:* = JSON.decode(event.target.data);
			if(jd.msg == 0)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_INFO,["数据导出成功，请选择本地保存位置。",fileDownload]);
			}
			else
			{				
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,jd.msgbox);
			}
			
			function fileDownload(event:CloseEvent):void
			{		
				var baseUrl:String = WebServiceProxy.BASE_URL;
				var url:String = encodeURI(baseUrl.substr(0,baseUrl.lastIndexOf("/")) + "/DownloadChart.aspx");
				
				var downloadURL:URLRequest = new URLRequest(encodeURI(url));				
				downloadURL.method = URLRequestMethod.POST;
				downloadURL.contentType = "text/plain";	
				downloadURL.data = encodeURIComponent(jd.msgbox);
				
				var fileRef:FileReference = new FileReference;
				fileRef.addEventListener(Event.SELECT,onFileSelect);	
				//fileRef.addEventListener(Event.CANCEL,onFileCancel);				
				fileRef.addEventListener(Event.COMPLETE,onDownloadFile);
				fileRef.addEventListener(IOErrorEvent.IO_ERROR,onIOError);			
				fileRef.download(downloadURL,xltname + ".xls");	
			}
			
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
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
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