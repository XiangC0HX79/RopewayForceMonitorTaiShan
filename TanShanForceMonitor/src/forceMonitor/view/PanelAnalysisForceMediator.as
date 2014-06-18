package forceMonitor.view
{
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
	
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.model.ConfigProxy;
	import forceMonitor.model.RopewayForceProxy;
	import forceMonitor.model.RopewayProxy;
	import forceMonitor.model.RopewaySwitchFreqProxy;
	import forceMonitor.model.WebServiceProxy;
	import forceMonitor.model.vo.ConfigVO;
	import forceMonitor.model.vo.RopewayForceVO;
	import forceMonitor.model.vo.RopewayVO;
	import forceMonitor.view.components.PanelAnalysisForce;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelAnalysisForceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisForceMediator";
		
		private var _whereClause:String = "";
		
		public function PanelAnalysisForceMediator()
		{
			super(NAME, new PanelAnalysisForce);
						
			panelAnalysisForce.addEventListener(PanelAnalysisForce.TABLE,onTable);
			panelAnalysisForce.addEventListener(PanelAnalysisForce.TABLE_PAGE,onTablePage);
			
			panelAnalysisForce.addEventListener(PanelAnalysisForce.CHART,onChart);
			
			panelAnalysisForce.addEventListener(PanelAnalysisForce.EXPORT,onExport);
			panelAnalysisForce.addEventListener(PanelAnalysisForce.STATION_CHANGE,onStationChange);
			panelAnalysisForce.addEventListener(PanelAnalysisForce.SELECT_ONE,onSelectOne);
		}
		
		override public function onRegister():void
		{							
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
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			var ropewayId:String = String(panelAnalysisForce.listRopewayId.selectedItem.ropewayId);			
			var temp1:Number = Number(panelAnalysisForce.numTempMin.text);
			var temp2:Number = Number(panelAnalysisForce.numTempMax.text);
			if(isNaN(temp1) || isNaN(temp2))
			{
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"请输入正确的查询温度值。");
				return;
			}
			
			if((panelAnalysisForce.numTempMin.text != "") && (panelAnalysisForce.numTempMax.text != ""))
			{
				if(temp2 < temp1)
				{					
					sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"查询最高温度不能小于最低温度。");
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
			var token:AsyncToken = proxy.GetForceHistory(this._whereClause);
			token.addResponder(new AsyncResponder(onChartResultHandle,function (error:FaultEvent, token:Object = null):void{}));
		}
		
		private function onChartResultHandle(result:Object, token:Object = null):void
		{
			panelAnalysisForce.UpdateChart();
		}
		
		private function onTable(event:Event):void
		{			
			if(panelAnalysisForce.dateE.time < panelAnalysisForce.dateS.time)
			{
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
						
			var temp1:Number = Number(panelAnalysisForce.numTempMin.text);
			var temp2:Number = Number(panelAnalysisForce.numTempMax.text);
			if(isNaN(temp1) || isNaN(temp2))
			{
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"请输入正确的查询温度值。");
				return;
			}
			
			if((panelAnalysisForce.numTempMin.text != "") && (panelAnalysisForce.numTempMax.text != ""))
			{
				if(temp2 < temp1)
				{					
					sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"查询最高温度不能小于最低温度。");
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
			sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"图形只能显示单一吊箱的数据，请先选择吊箱编号进行统计再切换至图形。");
		}			
		
		private const xltname:String = "历史抱索力";	
		
		private function onExport(event:Event):void
		{		
			if(panelAnalysisForce.dateE.time < panelAnalysisForce.dateS.time)
			{
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"导出时间段结束时间不能小于开始时间。");
				return;
			}
			
			var ropewayId:String = String(panelAnalysisForce.listRopewayId.selectedItem.ropewayId);	
			var selectAll:Boolean = (panelAnalysisForce.listRopewayId.selectedItem.ropewayId == "所有抱索器");
			
			if(selectAll)
			{
				var validDateE:Date = new Date(panelAnalysisForce.dateS.time);
				validDateE.month = validDateE.month + 1;
				
				if(panelAnalysisForce.dateE.time > validDateE.time)
				{					
					sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"所有抱索器导出时间段不能超过一个月。");
					return;
				}
			}
			
			var temp1:Number = Number(panelAnalysisForce.numTempMin.text);
			var temp2:Number = Number(panelAnalysisForce.numTempMax.text);
			if(isNaN(temp1) || isNaN(temp2))
			{
				sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"请输入正确的导出温度值。");
				return;
			}
			
			if((panelAnalysisForce.numTempMin.text != "") && (panelAnalysisForce.numTempMax.text != ""))
			{
				if(temp2 < temp1)
				{					
					sendNotification(ForceMonitorFacade.NOTIFY_ALERT_ALARM,"导出最高温度不能小于最低温度。");
					return;
				}
			}
			
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
						
			var baseUrl:String = WebServiceProxy.BASE_URL;
			var url:String = encodeURI(baseUrl.substr(0,baseUrl.lastIndexOf("/")) + "/ExportForce.aspx");
			
			var urlVar:URLVariables = new URLVariables;
			urlVar.type = panelAnalysisForce.selectOne?"chart":"table";
			urlVar.xltname = xltname;
			urlVar.whereClause = where;
			
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
					
					panelAnalysisForce.colStations = proxy.config.stations;	
					
					panelAnalysisForce.colRopeway.source = [RopewayVO.ALL];
					
					panelAnalysisForce.rbgStation.selectedValue = proxy.config.stations[0];
					
					changeStation(proxy.config.stations[0]);
					break;
			}
		}
	}
}