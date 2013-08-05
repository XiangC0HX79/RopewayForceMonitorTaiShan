package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewaySwitchFreqTotalProxy;
	import app.model.WebServiceProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewaySwitchFreqTotalVO;
	import app.view.components.PanelAnalysisOpenCountTotal;
	
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
	
	public class PanelAnalysisOpenCountTotalMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisOpenCountTotalMediator";
		
		private var _ropewaySwitchFreqTotalProxy:RopewaySwitchFreqTotalProxy;
		
		public function PanelAnalysisOpenCountTotalMediator()
		{
			super(NAME, new PanelAnalysisOpenCountTotal);
			
			panelAnalysisOpenCountTotal.addEventListener(PanelAnalysisOpenCountTotal.QUERY,onQuery);
			
			panelAnalysisOpenCountTotal.addEventListener(PanelAnalysisOpenCountTotal.EXPORT,onExport);
			
			_ropewaySwitchFreqTotalProxy = facade.retrieveProxy(RopewaySwitchFreqTotalProxy.NAME) as RopewaySwitchFreqTotalProxy;
			panelAnalysisOpenCountTotal.colRopeway = _ropewaySwitchFreqTotalProxy.colSwitchFreq;
		}
		
		protected function get panelAnalysisOpenCountTotal():PanelAnalysisOpenCountTotal
		{
			return viewComponent as PanelAnalysisOpenCountTotal;
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisOpenCountTotal.checkDatetime.selected
				&& (panelAnalysisOpenCountTotal.dateE.time < panelAnalysisOpenCountTotal.dateS.time))
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			_ropewaySwitchFreqTotalProxy.GetSwitchFreqCol(
				panelAnalysisOpenCountTotal.dateS
				,panelAnalysisOpenCountTotal.dateE
				,String(panelAnalysisOpenCountTotal.rbgStation.selectedValue)
				,panelAnalysisOpenCountTotal.checkDatetime.selected
			);
		}
				
		private const xltname:String = "总开合次数";	
		
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
			for each(var rf:RopewaySwitchFreqTotalVO in panelAnalysisOpenCountTotal.colRopeway)
			{
				json += rf.toString() + ",";
			}
			json = json.substr(0,json.length - 1) + "]";
			data.writeMultiByte(json, "GB2312");
			
			if(panelAnalysisOpenCountTotal.btnBar.selectedIndex == 0)
			{					
				var imgBD:BitmapData = new BitmapData(panelAnalysisOpenCountTotal.containerChart.width,panelAnalysisOpenCountTotal.containerChart.height,false,0xFFFFFF);
				imgBD.draw(panelAnalysisOpenCountTotal.containerChart);
				
				var jpegEncoder:JPEGEncoder = new JPEGEncoder;
				var ba:ByteArray = jpegEncoder.encode(imgBD);
				
				//开始封装图表图片					
				ts = "\r\n--" + bound + "\r\n" + "Content-Disposition: form-data; name=\"photo\"; filename=\"chart.jpg\";\r\n";
				ts += "Content-Type: image/jpg\r\n\r\n";
				
				data.position = data.length;
				data.writeMultiByte(ts, "GB2312");
				
				data.position = data.length;					
				data.writeBytes(ba);
			}
			
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
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					var config:ConfigVO = notification.getBody() as ConfigVO;	
					
					panelAnalysisOpenCountTotal.colStations = config.stations;	
					
					panelAnalysisOpenCountTotal.rbgStation.selectedValue = config.stations[0];
					break;
			}
		}
	}
}