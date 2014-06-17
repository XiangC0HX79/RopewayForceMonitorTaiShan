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
	import app.model.RopewayForceAverageProxy;
	import app.model.WebServiceProxy;
	import app.model.dict.RopewayDict;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.CarriageVO;
	import app.model.vo.ConfigVO;
	import app.model.vo.ForceVO;
	import app.model.vo.RopewayForceAverageVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.PanelForceAnalysisForceAverage;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelForceAnalysisForceAverageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelForceAnalysisForceAverageMediator";
		
		private var ropewayForceAverageProxy:RopewayForceAverageProxy;
		
		public function PanelForceAnalysisForceAverageMediator()
		{
			super(NAME, new PanelForceAnalysisForceAverage);
			
			panelAnalysisForceAverage.addEventListener(PanelForceAnalysisForceAverage.QUERY,onQuery);
			panelAnalysisForceAverage.addEventListener(PanelForceAnalysisForceAverage.STATION_CHANGE,onStationChange);
			panelAnalysisForceAverage.addEventListener(PanelForceAnalysisForceAverage.SELECT_ONE,onSelectOne);
			
			panelAnalysisForceAverage.addEventListener(PanelForceAnalysisForceAverage.EXPORT,onExport);
			
			ropewayForceAverageProxy = facade.retrieveProxy(RopewayForceAverageProxy.NAME) as RopewayForceAverageProxy;
			panelAnalysisForceAverage.colRopewayHis = ropewayForceAverageProxy.col;
		}
		
		protected function get panelAnalysisForceAverage():PanelForceAnalysisForceAverage
		{
			return viewComponent as PanelForceAnalysisForceAverage;
		}
		
		private function onStationChange(event:Event):void
		{			
			changeStation();
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
				,panelAnalysisForceAverage.selStation.fullName
				,panelAnalysisForceAverage.listRopewayId.selectedItem.ropewayId
				,panelAnalysisForceAverage.comboTime.selectedIndex
				);
		}
		
		private function onSelectOne(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"图形只能显示单一吊箱的数据，请先选择吊箱编号统计再切换至图形。");
		}		
		
		private function changeStation():void
		{
			var carriageProxy:CarriageProxy = facade.retrieveProxy(CarriageProxy.NAME) as CarriageProxy;
			
			panelAnalysisForceAverage.colCarriage = carriageProxy.GetCarriageWithForceAll(panelAnalysisForceAverage.selStation);
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
				//ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					panelAnalysisForceAverage.colStations = RopewayStationDict.list;	
					
					panelAnalysisForceAverage.selStation = panelAnalysisForceAverage.colStations[0];
					
					changeStation();
					break;
			}
		}
	}
}