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
	import com.adobe.utils.DateUtil;
	
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
		
		private var _whereClause:String;
		
		public function PanelAnalysisForceMediator()
		{
			super(NAME, new PanelAnalysisForce);
						
			panelAnalysisForce.addEventListener(PanelAnalysisForce.TABLE,onTable);
			panelAnalysisForce.addEventListener(PanelAnalysisForce.TABLE_PAGE,onTablePage);
			
			panelAnalysisForce.addEventListener(PanelAnalysisForce.CHART,onChart);
			
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
		
		private function onChart(event:Event):void
		{			
			if(panelAnalysisForce.dateE.time < panelAnalysisForce.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			var ropewayId:String = String(panelAnalysisForce.listRopewayId.selectedItem.ropewayId);
			if(ropewayId != "所有抱索器")
			{
				var validDateE:Date = DateUtil.addDateTime('M',3,panelAnalysisForce.dateS);
				
				if(panelAnalysisForce.dateE.time > validDateE.time)
				{					
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"单个抱索器查询时间段不能超过三个月。");
					return;
				}
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
			
			var dateS:Date = panelAnalysisForce.dateS;
			var dateE:Date= panelAnalysisForce.dateE;
			var station:String = String(panelAnalysisForce.rbgStation.selectedValue);
			var tempMin:String = panelAnalysisForce.numTempMin.text;
			var tempMax:String = panelAnalysisForce.numTempMax.text;
			
			var where:String = "";
			where = "DeteDate >= '" + DateUtil.toLocaleW3CDTF(dateS) 
				+ "' AND DeteDate < '" + DateUtil.toLocaleW3CDTF(dateE) + "'";
			
			if(station != "所有索道站")
				where += " AND FromRopeStation = '" + station + "'";
			
			if(ropewayId != "所有抱索器")
				where += " AND RopeCode = '" + ropewayId + "'";
			
			if(tempMin != "")
				where += " AND Temperature >= " + Number(tempMin);
			
			if(tempMax != "")
				where += " AND Temperature <= " + Number(tempMax);
			
			_whereClause =  where;
			
			var proxy:RopewayForceProxy = facade.retrieveProxy(RopewayForceProxy.NAME) as RopewayForceProxy;
			proxy.GetForceHistory(this._whereClause);
			
			trace(panelAnalysisForce.lineChart.width);
		}
		
		private function onTable(event:Event):void
		{			
			if(panelAnalysisForce.dateE.time < panelAnalysisForce.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			/*var ropewayId:String = String(panelAnalysisForce.listRopewayId.selectedItem.ropewayId);
			if(ropewayId != "所有抱索器")
			{
				var validDateE:Date = new Date(panelAnalysisForce.dateS.time);
				validDateE.month = validDateE.month + 3;
				
				if(panelAnalysisForce.dateE.time > validDateE.time)
				{					
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"单个抱索器查询时间段不能超过三个月。");
					return;
				}
			}*/
			
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
			
			var dateS:Date = panelAnalysisForce.dateS;
			var dateE:Date= panelAnalysisForce.dateE;
			var station:String = String(panelAnalysisForce.rbgStation.selectedValue);
			var ropewayId:String = panelAnalysisForce.listRopewayId.selectedItem.ropewayId;
			var tempMin:String = panelAnalysisForce.numTempMin.text;
			var tempMax:String = panelAnalysisForce.numTempMax.text;
						
			var where:String = "";
			where = "DeteDate >= '" + DateUtil.toLocaleW3CDTF(dateS) 
				+ "' AND DeteDate < '" + DateUtil.toLocaleW3CDTF(dateE) + "'";
			
			if(station != "所有索道站")
				where += " AND FromRopeStation = '" + station + "'";
			
			if(ropewayId != "所有抱索器")
				where += " AND RopeCode = '" + ropewayId + "'";
			
			if(tempMin != "")
				where += " AND Temperature >= " + Number(tempMin);
			
			if(tempMax != "")
				where += " AND Temperature <= " + Number(tempMax);
			
			_whereClause =  where;
			
			var proxy:RopewayForceProxy = facade.retrieveProxy(RopewayForceProxy.NAME) as RopewayForceProxy;
			var token:AsyncToken = proxy.GetForceHistory(this._whereClause,1);
			token.addResponder(new AsyncResponder(onTableResponder,function(event:FaultEvent,t:Object):void{}));
		}
		
		private function onTableResponder(event:ResultEvent,t:Object):void
		{
			var token:Object = event.token;
			
			panelAnalysisForce.totalCount = token.totalCount;
			panelAnalysisForce.pageCount = Math.ceil(token.totalCount / token.pageSize);
		}
		
		private function onTablePage(event:Event):void
		{						
			var proxy:RopewayForceProxy = facade.retrieveProxy(RopewayForceProxy.NAME) as RopewayForceProxy;
			proxy.GetForceHistory(this._whereClause,panelAnalysisForce.pageIndex);
		}
		
		private function onSelectOne(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"图形只能显示单一吊箱的数据，请先选择吊箱编号进行统计再切换至图形。");
		}			
		
		private const xltname:String = "历史抱索力";	
		
		private function onExport(event:Event):void
		{			
			var baseUrl:String = WebServiceProxy.BASE_URL;
			var url:String = encodeURI(baseUrl.substr(0,baseUrl.lastIndexOf("/")) + "/ExportChart.aspx");
			
			var urlVar:URLVariables = new URLVariables;
			urlVar.xltname = xltname;
			
			var data:String = "[";
			for each(var rf:RopewayForceVO in panelAnalysisForce.colRopewayHis)
			{
				data += rf.toString() + ",";
			}
			data = data.substr(0,data.length - 1) + "]";
			urlVar.data = data;
			
			if(panelAnalysisForce.btnBar.selectedIndex == 0)
			{					
				panelAnalysisForce.lbTitle.visible = true;
				
				var imgBD:BitmapData = new BitmapData(panelAnalysisForce.containerChart.width,panelAnalysisForce.containerChart.height,false,0xFFFFFF);
				imgBD.draw(panelAnalysisForce.containerChart);
				
				panelAnalysisForce.lbTitle.visible = false;
				
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
					
					panelAnalysisForce.colStations = proxy.config.stations;	
					
					panelAnalysisForce.colRopeway.source = [RopewayVO.ALL];
					
					panelAnalysisForce.rbgStation.selectedValue = proxy.config.stations[0];
					
					changeStation(proxy.config.stations[0]);
					break;
			}
		}
	}
}