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
	import app.model.ConfigProxy;
	import app.model.RopewayForceAverageProxy;
	import app.model.RopewayProxy;
	import app.model.WebServiceProxy;
	import app.model.vo.CarriageVO;
	import app.model.vo.ConfigVO;
	import app.model.vo.ForceVO;
	import app.model.vo.RopewayForceAverageVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.PanelAnalysisForceAverage;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelAnalysisForceAverageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisForceAverageMediator";
		
		private var ropewayForceAverageProxy:RopewayForceAverageProxy;
		
		public function PanelAnalysisForceAverageMediator()
		{
			super(NAME, new PanelAnalysisForceAverage);
			
			panelAnalysisForceAverage.addEventListener(PanelAnalysisForceAverage.QUERY,onQuery);
			panelAnalysisForceAverage.addEventListener(PanelAnalysisForceAverage.STATION_CHANGE,onStationChange);
			panelAnalysisForceAverage.addEventListener(PanelAnalysisForceAverage.SELECT_ONE,onSelectOne);
			
			panelAnalysisForceAverage.addEventListener(PanelAnalysisForceAverage.EXPORT,onExport);
			
			ropewayForceAverageProxy = facade.retrieveProxy(RopewayForceAverageProxy.NAME) as RopewayForceAverageProxy;
			panelAnalysisForceAverage.colRopewayHis = ropewayForceAverageProxy.col;
		}
		
		protected function get panelAnalysisForceAverage():PanelAnalysisForceAverage
		{
			return viewComponent as PanelAnalysisForceAverage;
		}
		
		private function onStationChange(event:Event):void
		{
			var station:String = String(panelAnalysisForceAverage.rbgStation.selectedValue);
			
			changeStation(station);
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisForceAverage.dateE.time < panelAnalysisForceAverage.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			panelAnalysisForceAverage.selectOne = (panelAnalysisForceAverage.listRopewayId.selectedItem.ropewayId != "所有抱索器");
			
			ropewayForceAverageProxy.GetForceAveCol(
				panelAnalysisForceAverage.dateS
				,panelAnalysisForceAverage.dateE
				,String(panelAnalysisForceAverage.rbgStation.selectedValue)
				,panelAnalysisForceAverage.listRopewayId.selectedItem.ropewayId
				,panelAnalysisForceAverage.comboTime.selectedIndex
				);
		}
		
		private function onSelectOne(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"图形只能显示单一吊箱的数据，请先选择吊箱编号统计再切换至图形。");
		}		
		
		private function changeStation(station:String):void
		{
			var arr:Array = [];
			if(station != "所有索道站")
			{
				var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
				for each(var r:RopewayStationForceVO in proxy.colRopeway)
				{
					//if(r.ropewayStation == station)
					{
						arr.push(r);
					}
				}
			}
			
			arr.sortOn("ropewayCarId");
			
			arr.unshift(CarriageVO.ALL);
			
			panelAnalysisForceAverage.colRopeway.source = arr;
		}	
		
		private const xltname:String = "平均抱索力";
		
		private function onExport(event:Event):void
		{			
			var baseUrl:String = WebServiceProxy.BASE_URL;
			var url:String = encodeURI(baseUrl.substr(0,baseUrl.lastIndexOf("/")) + "/ExportChart.aspx");
			
			var urlVar:URLVariables = new URLVariables;
			urlVar.xltname = xltname;
			
			var data:String = "[";
			for each(var rf:RopewayForceAverageVO in panelAnalysisForceAverage.colRopewayHis)
			{
				data += rf.toString() + ",";
			}
			data = data.substr(0,data.length - 1) + "]";
			urlVar.data = data;
			
			if(panelAnalysisForceAverage.btnBar.selectedIndex == 0)
			{					
				var imgBD:BitmapData = new BitmapData(panelAnalysisForceAverage.containerChart.width,panelAnalysisForceAverage.containerChart.height,false,0xFFFFFF);
				imgBD.draw(panelAnalysisForceAverage.containerChart);
				
				var jpegEncoder:JPEGEncoder = new JPEGEncoder;
				var ba:ByteArray = jpegEncoder.encode(imgBD);
				ba.position = 0;
				
				var image:String = "";
				while(ba.bytesAvailable)
				{
					var n:Number = ba.readUnsignedByte();
					image += (n <= 0xF)?"0" + n.toString(16):n.toString(16);
				}
				
				urlVar.image = image;
			}
			
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
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					var proxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					
					panelAnalysisForceAverage.colStations = proxy.config.stations;	
					
					panelAnalysisForceAverage.colRopeway.source = [CarriageVO.ALL];
					
					panelAnalysisForceAverage.rbgStation.selectedValue = proxy.config.stations[0];
					
					changeStation(proxy.config.stations[0]);
					break;
			}
		}
	}
}