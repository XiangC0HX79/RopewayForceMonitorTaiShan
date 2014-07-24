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
	import app.view.components.PanelEngineAnalysisValue;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelEngineAnalysisValueMediator extends Mediator
	{
		public static const NAME:String = "PanelEngineAnalysisValueMediator";
		
		public function PanelEngineAnalysisValueMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelEngineAnalysisValue():PanelEngineAnalysisValue
		{
			return viewComponent as PanelEngineAnalysisValue;
		}
		
		override public function onRegister():void
		{			
			panelEngineAnalysisValue.addEventListener(PanelEngineAnalysisValue.TABLE,onTable);
			panelEngineAnalysisValue.addEventListener(PanelEngineAnalysisValue.CHART,onChart);
			
			panelEngineAnalysisValue.addEventListener(PanelEngineAnalysisValue.EXPORT,onExport);
		}
		
		override public function onRemove():void
		{			
			panelEngineAnalysisValue.removeEventListener(PanelEngineAnalysisValue.TABLE,onTable);
			panelEngineAnalysisValue.removeEventListener(PanelEngineAnalysisValue.CHART,onChart);
			
			panelEngineAnalysisValue.removeEventListener(PanelEngineAnalysisValue.EXPORT,onExport);
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
					panelEngineAnalysisValue.ropeway = RopewayVO(notification.getBody());
					break;
			}
		}		
		
		private function onExport(event:Event):void
		{
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.sTime = panelEngineAnalysisValue.sTime;
			notify.eTime = panelEngineAnalysisValue.eTime;
			notify.device = DeviceVO(panelEngineAnalysisValue.rbgPos.selectedValue);
			
			sendNotification(ApplicationFacade.NOTIFY_VALUE_EXPORT,notify);			
		}
		
		private function onChart(event:Event):void
		{			
			var notify:AnalysisValueChartNotify = new AnalysisValueChartNotify;
			notify.sTime = panelEngineAnalysisValue.sTime;
			notify.eTime = panelEngineAnalysisValue.eTime;
			notify.mTime = panelEngineAnalysisValue.mTime;
			notify.chartSize = panelEngineAnalysisValue.chartSize;
			notify.device = DeviceVO(panelEngineAnalysisValue.rbgPos.selectedValue);
			
			notify.ResultHandle = chartResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_VALUE_CHART,notify);
		}
		
		private function chartResultHandle(colChart:ArrayCollection,minTime:Date,maxTime:Date,minSpeed:Number,maxSpeed:Number):void
		{
			panelEngineAnalysisValue.colChart = colChart;
			panelEngineAnalysisValue.chartMaxSpeed = maxSpeed;
			panelEngineAnalysisValue.chartMaxTime = maxTime;
			panelEngineAnalysisValue.chartMinSpeed = minSpeed;
			panelEngineAnalysisValue.chartMinTime = minTime;
		}
		
		private function onTable(event:Event):void
		{
			var notify:AnalysisValueTableNotify = new AnalysisValueTableNotify;
			notify.sTime = panelEngineAnalysisValue.sTime;
			notify.eTime = panelEngineAnalysisValue.eTime;
			notify.pageIndex = panelEngineAnalysisValue.pageIndex;
			notify.pageSize = PanelEngineAnalysisValue.PAGESIZE;
			notify.device = DeviceVO(panelEngineAnalysisValue.rbgPos.selectedValue);
			
			notify.ResultHandle = tableResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_VALUE_TABLE,notify);
		}		
		
		private function tableResultHandle(totalCount:int,colGrid:ArrayCollection):void
		{
			panelEngineAnalysisValue.totalCount = totalCount;
			panelEngineAnalysisValue.colGrid = colGrid;			
		}
	}
}