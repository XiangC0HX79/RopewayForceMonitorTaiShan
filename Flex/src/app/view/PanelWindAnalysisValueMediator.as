package app.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.controller.notify.AnalysisNotify;
	import app.controller.notify.AnalysisValueChartNotify;
	import app.controller.notify.AnalysisValueTableNotify;
	import app.model.vo.DeviceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelWindAnalysisValue;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelWindAnalysisValueMediator extends Mediator
	{
		public static const NAME:String = "PanelWindAnalysisValueMediator";
		
		public function PanelWindAnalysisValueMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelWindAnalysisValue():PanelWindAnalysisValue
		{
			return viewComponent as PanelWindAnalysisValue;
		}
		
		override public function onRegister():void
		{
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisValue.SELECT_ONT,onSelectOne);
			
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisValue.TABLE,onTablePageChange);
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisValue.CHART,onChartDateChange);
			
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisValue.EXPORT,onExport);
		}
		
		override public function onRemove():void
		{
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisValue.SELECT_ONT,onSelectOne);
			
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisValue.TABLE,onTablePageChange);
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisValue.CHART,onChartDateChange);
			
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisValue.EXPORT,onExport);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_ROPEWAY
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_ROPEWAY:
					panelWindAnalysisValue.colBracket = RopewayVO(notification.getBody()).colAllBracket;
					break;
			}
		}		
		
		private function onSelectOne(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"图形只能显示单一吊箱的数据，请先选择吊箱编号进行统计再切换至图形。");
		}			
		
		private function onExport(event:Event):void
		{
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = DeviceVO(panelWindAnalysisValue.listBracket.selectedItem);
			notify.sTime = panelWindAnalysisValue.sTime;
			notify.eTime = panelWindAnalysisValue.eTime;
			
			sendNotification(ApplicationFacade.NOTIFY_VALUE_EXPORT,notify);			
		}
		
		private function onChartDateChange(event:Event):void
		{			
			var notify:AnalysisValueChartNotify = new AnalysisValueChartNotify;
			notify.device = DeviceVO(panelWindAnalysisValue.listBracket.selectedItem);
			notify.sTime = panelWindAnalysisValue.sTime;
			notify.eTime = panelWindAnalysisValue.eTime;
			notify.mTime = panelWindAnalysisValue.mTime;
			notify.chartSize = panelWindAnalysisValue.chartSize;
			
			notify.ResultHandle = chartResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_VALUE_CHART,notify);
		}
		
		private function chartResultHandle(colChart:ArrayCollection,minTime:Date,maxTime:Date,minSpeed:Number,maxSpeed:Number):void
		{
			panelWindAnalysisValue.colChart = colChart;
			panelWindAnalysisValue.chartMaxSpeed = maxSpeed;
			panelWindAnalysisValue.chartMaxTime = maxTime;
			panelWindAnalysisValue.chartMinSpeed = minSpeed;
			panelWindAnalysisValue.chartMinTime = minTime;
		}
		
		private function onTablePageChange(event:Event):void
		{
			var notify:AnalysisValueTableNotify = new AnalysisValueTableNotify;
			notify.device = DeviceVO(panelWindAnalysisValue.listBracket.selectedItem);
			notify.sTime = panelWindAnalysisValue.sTime;
			notify.eTime = panelWindAnalysisValue.eTime;
			notify.pageIndex = panelWindAnalysisValue.pageIndex;
			notify.pageSize = PanelWindAnalysisValue.PAGESIZE;
			
			notify.ResultHandle = pageChangeResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_VALUE_TABLE,notify);
		}		
		
		private function pageChangeResultHandle(totalCount:int,colGrid:ArrayCollection):void
		{
			panelWindAnalysisValue.totalCount = totalCount;
			panelWindAnalysisValue.colGrid = colGrid;			
		}
	}
}