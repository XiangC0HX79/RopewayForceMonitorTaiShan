package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayForceProxy;
	import app.model.RopewayProxy;
	import app.model.WebServiceProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelAnalysisForce;
	
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
	import flash.utils.setTimeout;
	
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
	
	public class PanelAnalysisForceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisForceMediator";
		
		public function PanelAnalysisForceMediator()
		{
			super(NAME, new PanelAnalysisForce);
			
			panelAnalysisForce.addEventListener(PanelAnalysisForce.QUERY,onQuery);
			panelAnalysisForce.addEventListener(PanelAnalysisForce.EXPORT,onExport);
			panelAnalysisForce.addEventListener(PanelAnalysisForce.STATION_CHANGE,onStationChange);
			panelAnalysisForce.addEventListener(PanelAnalysisForce.SELECT_ONE,onSelectOne);
			
			var ropewayForceProxy:RopewayForceProxy = facade.retrieveProxy(RopewayForceProxy.NAME) as RopewayForceProxy;
			panelAnalysisForce.colRopewayHis = ropewayForceProxy.col;
		}
		
		protected function get panelAnalysisForce():PanelAnalysisForce
		{
			return viewComponent as PanelAnalysisForce;
		}
		
		private function onStationChange(event:Event):void
		{
			var station:String = String(panelAnalysisForce.rbgStation.selectedValue);
			
			changeStation(station);
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
			
			panelAnalysisForce.colRopeway.source = arr;
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisForce.dateE.time < panelAnalysisForce.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			var temp1:Number = Number(panelAnalysisForce.numTempMin.text);
			var temp2:Number = Number(panelAnalysisForce.numTempMax.text);
			if(isNaN(temp1) || isNaN(temp2))
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入正确的查询温度值。");
				return;
			}
			
			if((panelAnalysisForce.numTempMin.text != "") && (panelAnalysisForce.numTempMax.text != ""))
			{
				if(temp2 < temp1)
				{					
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询最高温度不能小于最低温度。");
					return;
				}
			}
			
			panelAnalysisForce.selectOne = (panelAnalysisForce.listRopewayId.selectedItem.ropewayId != "所有抱索器");
			
			var proxy:RopewayForceProxy = facade.retrieveProxy(RopewayForceProxy.NAME) as RopewayForceProxy;
			var token:AsyncToken = proxy.GetForceHistory(
				panelAnalysisForce.dateS
				,panelAnalysisForce.dateE
				,String(panelAnalysisForce.rbgStation.selectedValue)
				,panelAnalysisForce.listRopewayId.selectedItem.ropewayId
				,panelAnalysisForce.numTempMin.text
				,panelAnalysisForce.numTempMax.text
				);;
		}
		
		private function onSelectOne(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"图形只能显示单一吊箱的数据，请先选择吊箱编号进行统计再切换至图形。");
		}			
		
		private const xltname:String = "历史抱索力";	
		
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
			for each(var rf:RopewayForceVO in panelAnalysisForce.colRopewayHis)
			{
				json += rf.toString() + ",";
			}
			json = json.substr(0,json.length - 1) + "]";
			data.writeMultiByte(json, "GB2312");
			
			if(panelAnalysisForce.btnBar.selectedIndex == 0)
			{					
				var imgBD:BitmapData = new BitmapData(panelAnalysisForce.containerChart.width,panelAnalysisForce.containerChart.height,false,0xFFFFFF);
				imgBD.draw(panelAnalysisForce.containerChart);
				
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
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					var proxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					
					panelAnalysisForce.colStations = proxy.config.stations;	
					
					panelAnalysisForce.colRopeway.source = [RopewayVO.ALL];
					
					panelAnalysisForce.rbgStation.selectedValue = proxy.config.stations[0];
					
					changeStation(proxy.config.stations[0]);
					break;
			}
		}
	}
}