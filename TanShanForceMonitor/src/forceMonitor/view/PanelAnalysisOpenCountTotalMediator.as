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
	import forceMonitor.model.RopeForceAjustProxy;
	import forceMonitor.model.RopewaySwitchFreqTotalProxy;
	import forceMonitor.model.WebServiceProxy;
	import forceMonitor.model.vo.ConfigVO;
	import forceMonitor.model.vo.RopewaySwitchFreqTotalVO;
	import forceMonitor.view.components.PanelAnalysisOpenCountTotal;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelAnalysisOpenCountTotalMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisOpenCountTotalMediator";
		
		private var _ropewaySwitchFreqTotalProxy:RopewaySwitchFreqTotalProxy;
		
		public function PanelAnalysisOpenCountTotalMediator()
		{
			super(NAME, new PanelAnalysisOpenCountTotal);
			
			panelAnalysisOpenCountTotal.addEventListener(PanelAnalysisOpenCountTotal.QUERY,onQuery);
			
			panelAnalysisOpenCountTotal.addEventListener(PanelAnalysisOpenCountTotal.EXPORT,onExport);
		}
		
		override public function onRegister():void
		{												
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
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
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
			var baseUrl:String = WebServiceProxy.BASE_URL;
			var url:String = encodeURI(baseUrl.substr(0,baseUrl.lastIndexOf("/")) + "/ExportChart.aspx");
			
			var urlVar:URLVariables = new URLVariables;
			urlVar.xltname = xltname;
			
			var data:String = "[";
			for each(var rf:RopewaySwitchFreqTotalVO in panelAnalysisOpenCountTotal.colRopeway)
			{
				data += rf.toString() + ",";
			}
			data = data.substr(0,data.length - 1) + "]";
			urlVar.data = data;
			
			if(panelAnalysisOpenCountTotal.btnBar.selectedIndex == 0)
			{					
				var imgBD:BitmapData = new BitmapData(panelAnalysisOpenCountTotal.containerChart.width,panelAnalysisOpenCountTotal.containerChart.height,false,0xFFFFFF);
				imgBD.draw(panelAnalysisOpenCountTotal.containerChart);
				
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
				ForceMonitorFacade.NOTIFY_INIT_CONFIG_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForceMonitorFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					var config:ConfigVO = notification.getBody() as ConfigVO;	
					
					panelAnalysisOpenCountTotal.colStations = config.stations;	
					
					panelAnalysisOpenCountTotal.rbgStation.selectedValue = config.stations[0];
					break;
			}
		}
	}
}