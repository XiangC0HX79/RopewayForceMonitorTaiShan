package app.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.controller.notify.AnalysisNotify;
	import app.controller.notify.AnalysisValueChartNotify;
	import app.controller.notify.AnalysisValueTableNotify;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelInchAnalysisValue;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelInchAnalysisValueMediator extends Mediator
	{
		public static const NAME:String = "PanelInchAnalysisValueMediator";
		
		public function PanelInchAnalysisValueMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelInchAnalysisValue():PanelInchAnalysisValue
		{
			return viewComponent as PanelInchAnalysisValue;
		}
		
		override public function onRegister():void
		{			
			panelInchAnalysisValue.addEventListener(PanelInchAnalysisValue.TABLE,onTable);
			panelInchAnalysisValue.addEventListener(PanelInchAnalysisValue.CHART,onChart);
			
			panelInchAnalysisValue.addEventListener(PanelInchAnalysisValue.EXPORT,onExport);
		}
		
		override public function onRemove():void
		{			
			panelInchAnalysisValue.removeEventListener(PanelInchAnalysisValue.TABLE,onTable);
			panelInchAnalysisValue.removeEventListener(PanelInchAnalysisValue.CHART,onChart);
			
			panelInchAnalysisValue.removeEventListener(PanelInchAnalysisValue.EXPORT,onExport);
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
					panelInchAnalysisValue.inch = RopewayVO(notification.getBody()).inch;
					break;
			}
		}		
		
		private function onExport(event:Event):void
		{
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.sTime = panelInchAnalysisValue.sTime;
			notify.eTime = panelInchAnalysisValue.eTime;
			notify.device = panelInchAnalysisValue.inch;
			
			sendNotification(ApplicationFacade.NOTIFY_VALUE_EXPORT,notify);			
		}
		
		private function onChart(event:Event):void
		{			
			var notify:AnalysisValueChartNotify = new AnalysisValueChartNotify;
			notify.sTime = panelInchAnalysisValue.sTime;
			notify.eTime = panelInchAnalysisValue.eTime;
			notify.mTime = panelInchAnalysisValue.mTime;
			notify.chartSize = panelInchAnalysisValue.chartSize;
			notify.device = panelInchAnalysisValue.inch;
			
			notify.ResultHandle = chartResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_VALUE_CHART,notify);
		}
		
		private function chartResultHandle(colChart:ArrayCollection,minTime:Date,maxTime:Date,minSpeed:Number,maxSpeed:Number):void
		{
			panelInchAnalysisValue.colChart = colChart;
			panelInchAnalysisValue.chartMaxSpeed = maxSpeed;
			panelInchAnalysisValue.chartMaxTime = maxTime;
			panelInchAnalysisValue.chartMinSpeed = minSpeed;
			panelInchAnalysisValue.chartMinTime = minTime;
		}
		
		private function onTable(event:Event):void
		{
			var notify:AnalysisValueTableNotify = new AnalysisValueTableNotify;
			notify.sTime = panelInchAnalysisValue.sTime;
			notify.eTime = panelInchAnalysisValue.eTime;
			notify.pageIndex = panelInchAnalysisValue.pageIndex;
			notify.pageSize = PanelInchAnalysisValue.PAGESIZE;
			notify.device = panelInchAnalysisValue.inch;
			
			notify.ResultHandle = tableResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_VALUE_TABLE,notify);
		}		
		
		private function tableResultHandle(totalCount:int,colGrid:ArrayCollection):void
		{
			panelInchAnalysisValue.totalCount = totalCount;
			panelInchAnalysisValue.colGrid = colGrid;			
		}
	}
}