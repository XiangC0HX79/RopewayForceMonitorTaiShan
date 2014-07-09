package app.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.notify.NotifyWindAnalysisValueVO;
	import app.model.vo.BracketVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelWindAnalysisValue;
	
	import custom.event.GridNavigatorEvent;
	
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
			
			panelWindAnalysisValue.addEventListener(GridNavigatorEvent.PAGE_CHANGE,onPageChange);
			
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisValue.CHART,onChart);
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisValue.EXPORT,onExport);
		}
		
		override public function onRemove():void
		{
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisValue.SELECT_ONT,onSelectOne);
			
			panelWindAnalysisValue.removeEventListener(GridNavigatorEvent.PAGE_CHANGE,onPageChange);
			
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisValue.CHART,onChart);
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
			var notify:NotifyWindAnalysisValueVO = new NotifyWindAnalysisValueVO;
			notify.bracket = BracketVO(panelWindAnalysisValue.listBracket.selectedItem);
			notify.sTime = panelWindAnalysisValue.sTime;
			notify.eTime = panelWindAnalysisValue.eTime;
			
			sendNotification(ApplicationFacade.NOTIFY_WIND_VALUE_EXPORT,notify);			
		}
		
		private function onChart(event:Event):void
		{			
			var notify:NotifyWindAnalysisValueVO = new NotifyWindAnalysisValueVO;
			notify.bracket = BracketVO(panelWindAnalysisValue.listBracket.selectedItem);
			notify.sTime = panelWindAnalysisValue.sTime;
			notify.eTime = panelWindAnalysisValue.eTime;
			
			notify.ResultHandle = chartResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_WIND_VALUE_CHART,notify);
		}
		
		private function chartResultHandle(colChart:ArrayCollection):void
		{
			panelWindAnalysisValue.colChart = colChart;
		}
		
		private function onPageChange(event:GridNavigatorEvent):void
		{
			var notify:NotifyWindAnalysisValueVO = new NotifyWindAnalysisValueVO;
			notify.bracket = BracketVO(panelWindAnalysisValue.listBracket.selectedItem);
			notify.sTime = panelWindAnalysisValue.sTime;
			notify.eTime = panelWindAnalysisValue.eTime;
			notify.pageIndex = event.pageIndex;
			notify.pageSize = PanelWindAnalysisValue.PAGESIZE;
			
			notify.ResultHandle = pageChangeResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_WIND_VALUE_PAGE_CHANGE,notify);
		}		
		
		private function pageChangeResultHandle(totalCount:int,colGrid:ArrayCollection):void
		{
			panelWindAnalysisValue.totalCount = totalCount;
			panelWindAnalysisValue.colGrid = colGrid;			
		}
	}
}