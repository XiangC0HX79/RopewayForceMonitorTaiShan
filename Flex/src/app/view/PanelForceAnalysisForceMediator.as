package app.view
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
	
	import app.ApplicationFacade;
	import app.model.CarriageProxy;
	import app.model.ConfigProxy;
	import app.model.RopewayForceProxy;
	import app.model.WebServiceProxy;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.CarriageVO;
	import app.model.vo.ConfigVO;
	import app.model.vo.ForceVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.PanelForceAnalysisForce;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelForceAnalysisForceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelForceAnalysisForceMediator";
		
		private var _whereClause:String = "";
		
		private var ropewayForceProxy:RopewayForceProxy;
		
		public function PanelForceAnalysisForceMediator()
		{
			super(NAME, new PanelForceAnalysisForce);
						
			panelAnalysisForce.addEventListener(PanelForceAnalysisForce.TABLE,onTable);
			panelAnalysisForce.addEventListener(PanelForceAnalysisForce.TABLE_PAGE,onTablePage);
			
			panelAnalysisForce.addEventListener(PanelForceAnalysisForce.CHART,onChart);
			
			panelAnalysisForce.addEventListener(PanelForceAnalysisForce.EXPORT,onExport);
			panelAnalysisForce.addEventListener(PanelForceAnalysisForce.STATION_CHANGE,onStationChange);
			panelAnalysisForce.addEventListener(PanelForceAnalysisForce.SELECT_ONE,onSelectOne);
			
			ropewayForceProxy = facade.retrieveProxy(RopewayForceProxy.NAME) as RopewayForceProxy;
			panelAnalysisForce.colRopewayHis = ropewayForceProxy.col;
		}
		
		protected function get panelAnalysisForce():PanelForceAnalysisForce
		{
			return viewComponent as PanelForceAnalysisForce;
		}
					
		private function onStationChange(event:Event):void
		{
			changeStation();
		}
		
		private function changeStation():void
		{
			var carriageProxy:CarriageProxy = facade.retrieveProxy(CarriageProxy.NAME) as CarriageProxy;
			
			panelAnalysisForce.colCarriage = carriageProxy.GetCarriageWithForceAll(panelAnalysisForce.selStation);
		}
		
		private function onChart(event:Event):void
		{			
			if(panelAnalysisForce.dateE.time < panelAnalysisForce.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			var ropewayId:String = String(panelAnalysisForce.listRopewayId.selectedItem.ropewayId);			
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
			var station:String = panelAnalysisForce.selStation.fullName;
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
						
			var token:AsyncToken = ropewayForceProxy.GetForceHistory(this._whereClause);
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
			
			var dateS:Date = panelAnalysisForce.dateS;
			var dateE:Date= panelAnalysisForce.dateE;
			var station:String = panelAnalysisForce.selStation.fullName;
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
			
			var token:AsyncToken = ropewayForceProxy.GetForceHistory(this._whereClause,1);
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
			ropewayForceProxy.GetForceHistory(this._whereClause,panelAnalysisForce.pageIndex);
		}
		
		private function onSelectOne(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"图形只能显示单一吊箱的数据，请先选择吊箱编号进行统计再切换至图形。");
		}			
		
		private const xltname:String = "历史抱索力";	
		
		private function onExport(event:Event):void
		{		
			if(panelAnalysisForce.dateE.time < panelAnalysisForce.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"导出时间段结束时间不能小于开始时间。");
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
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"所有抱索器导出时间段不能超过一个月。");
					return;
				}
			}
			
			var temp1:Number = Number(panelAnalysisForce.numTempMin.text);
			var temp2:Number = Number(panelAnalysisForce.numTempMax.text);
			if(isNaN(temp1) || isNaN(temp2))
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入正确的导出温度值。");
				return;
			}
			
			if((panelAnalysisForce.numTempMin.text != "") && (panelAnalysisForce.numTempMax.text != ""))
			{
				if(temp2 < temp1)
				{					
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"导出最高温度不能小于最低温度。");
					return;
				}
			}
			
			var dateS:Date = panelAnalysisForce.dateS;
			var dateE:Date= panelAnalysisForce.dateE;
			var station:String = panelAnalysisForce.selStation.fullName;
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
					panelAnalysisForce.colStations = RopewayStationDict.list;	
					
					panelAnalysisForce.selStation = panelAnalysisForce.colStations[0];
					
					changeStation();
					break;
			}
		}
	}
}