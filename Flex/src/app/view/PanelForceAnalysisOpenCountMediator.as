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
	import app.model.RopewaySwitchFreqProxy;
	import app.model.WebServiceProxy;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.CarriageVO;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayStationForceVO;
	import app.model.vo.RopewaySwitchFreqVO;
	import app.view.components.PanelForceAnalysisOpenCount;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelForceAnalysisOpenCountMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelForceAnalysisOpenCountMediator";
		
		private var _ropewaySwitchFreqProxy:RopewaySwitchFreqProxy;
		
		public function PanelForceAnalysisOpenCountMediator()
		{
			super(NAME, new PanelForceAnalysisOpenCount);
			
			panelAnalysisOpenCount.addEventListener(PanelForceAnalysisOpenCount.QUERY,onQuery);
			panelAnalysisOpenCount.addEventListener(PanelForceAnalysisOpenCount.STATION_CHANGE,onStationChange);
			panelAnalysisOpenCount.addEventListener(PanelForceAnalysisOpenCount.SELECT_ONE,onSelectOne);
			
			panelAnalysisOpenCount.addEventListener(PanelForceAnalysisOpenCount.EXPORT,onExport);
			
			_ropewaySwitchFreqProxy = facade.retrieveProxy(RopewaySwitchFreqProxy.NAME) as RopewaySwitchFreqProxy;
			panelAnalysisOpenCount.colSwitchFreq = _ropewaySwitchFreqProxy.colSwitchFreq;
		}
		
		protected function get panelAnalysisOpenCount():PanelForceAnalysisOpenCount
		{
			return viewComponent as PanelForceAnalysisOpenCount;
		}
		
		private function onStationChange(event:Event):void
		{
			changeStation();
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisOpenCount.dateE.time < panelAnalysisOpenCount.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			panelAnalysisOpenCount.selectOne = (panelAnalysisOpenCount.listRopewayId.selectedItem.ropewayId != "所有抱索器");
			
			_ropewaySwitchFreqProxy.GetSwitchFreqCol(
				panelAnalysisOpenCount.dateS
				,panelAnalysisOpenCount.dateE
				,panelAnalysisOpenCount.selStation.fullName
				,panelAnalysisOpenCount.listRopewayId.selectedItem.ropewayId
				,panelAnalysisOpenCount.comboTime.selectedIndex
			);
		}
		
		private function onSelectOne(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"图形只能显示单一吊箱的数据，请先选择吊箱编号再切换至图形。");
		}			
		
		private function changeStation():void
		{
			var carriageProxy:CarriageProxy = facade.retrieveProxy(CarriageProxy.NAME) as CarriageProxy;
			
			panelAnalysisOpenCount.colCarriage = carriageProxy.GetCarriageWithForceAll(panelAnalysisOpenCount.selStation);
		}		
		
		private const xltname:String = "开合次数";	
		
		private function onExport(event:Event):void
		{			
			var baseUrl:String = WebServiceProxy.BASE_URL;
			var url:String = encodeURI(baseUrl.substr(0,baseUrl.lastIndexOf("/")) + "/ExportChart.aspx");
			
			var urlVar:URLVariables = new URLVariables;
			urlVar.xltname = xltname;
			
			var data:String = "[";
			for each(var rf:RopewaySwitchFreqVO in panelAnalysisOpenCount.colSwitchFreq)
			{
				data += rf.toString() + ",";
			}
			data = data.substr(0,data.length - 1) + "]";
			urlVar.data = data;
			
			if(panelAnalysisOpenCount.btnBar.selectedIndex == 0)
			{					
				var imgBD:BitmapData = new BitmapData(panelAnalysisOpenCount.containerChart.width,panelAnalysisOpenCount.containerChart.height,false,0xFFFFFF);
				imgBD.draw(panelAnalysisOpenCount.containerChart);
				
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
					panelAnalysisOpenCount.colStations = RopewayStationDict.list;	
					
					panelAnalysisOpenCount.selStation = panelAnalysisOpenCount.colStations[0];
					
					changeStation();
					break;
			}
		}
	}
}