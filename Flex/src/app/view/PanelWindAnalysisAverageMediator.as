package app.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.controller.notify.AnalysisNotify;
	import app.model.vo.DeviceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelWindAnalysisAverage;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelWindAnalysisAverageMediator extends Mediator
	{
		public static const NAME:String = "PanelWindAnalysisAverageMediator";
		
		public function PanelWindAnalysisAverageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelWindAnalysisValue():PanelWindAnalysisAverage
		{
			return viewComponent as PanelWindAnalysisAverage;
		}
		
		override public function onRegister():void
		{
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisAverage.SELECT_ONE,onSelectOne);
						
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisAverage.QUERY_DAY,onQueryDay);
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisAverage.QUERY_MONTH,onQueryMonth);
			
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisAverage.EXPORT_DAY,onExportDay);
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisAverage.EXPORT_MONTH,onExportMonth);
		}
		
		override public function onRemove():void
		{
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisAverage.SELECT_ONE,onSelectOne);
			
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisAverage.QUERY_DAY,onQueryDay);
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisAverage.QUERY_MONTH,onQueryMonth);
						
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisAverage.EXPORT_DAY,onExportDay);
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisAverage.EXPORT_MONTH,onExportMonth);
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
		
		private function onExportDay(event:Event):void
		{
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = DeviceVO(panelWindAnalysisValue.listBracket.selectedItem);
			notify.sTime = panelWindAnalysisValue.sTime;
			notify.eTime = panelWindAnalysisValue.eTime;
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_EXPORT_DAY,notify);			
		}			
		
		private function onExportMonth(event:Event):void
		{
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = DeviceVO(panelWindAnalysisValue.listBracket.selectedItem);
			notify.sTime = panelWindAnalysisValue.sTime;
			notify.eTime = panelWindAnalysisValue.eTime;
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_EXPORT_MONTH,notify);			
		}
		
		private function onQueryDay(event:Event):void
		{			
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = DeviceVO(panelWindAnalysisValue.listBracket.selectedItem);
			notify.sTime = panelWindAnalysisValue.sTime;
			notify.eTime = panelWindAnalysisValue.eTime;
			
			notify.ResultHandle = queryDayResultHandle;			
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_QUERY_DAY,notify);
		}
		
		private function queryDayResultHandle(colWindAve:ArrayCollection):void
		{
			panelWindAnalysisValue.colWindAve = colWindAve;
		}
		
		private function onQueryMonth(event:Event):void
		{			
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = DeviceVO(panelWindAnalysisValue.listBracket.selectedItem);
			notify.sTime = panelWindAnalysisValue.sTime;
			notify.eTime = panelWindAnalysisValue.eTime;
			
			notify.ResultHandle = queryMonthResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_QUERY_MONTH,notify);
		}
		
		private function queryMonthResultHandle(colWindAve:ArrayCollection):void
		{
			panelWindAnalysisValue.colWindAve = colWindAve;
		}
	}
}