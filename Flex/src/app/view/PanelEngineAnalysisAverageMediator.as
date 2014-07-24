package app.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.controller.notify.AnalysisNotify;
	import app.model.vo.DeviceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelEngineAnalysisAverage;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelEngineAnalysisAverageMediator extends Mediator
	{
		public static const NAME:String = "PanelEngineAnalysisAverageMediator";
		
		public function PanelEngineAnalysisAverageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelEngineAnalysisAverage():PanelEngineAnalysisAverage
		{
			return viewComponent as PanelEngineAnalysisAverage;
		}
		
		override public function onRegister():void
		{						
			panelEngineAnalysisAverage.addEventListener(PanelEngineAnalysisAverage.QUERY_DAY,onQueryDay);
			panelEngineAnalysisAverage.addEventListener(PanelEngineAnalysisAverage.QUERY_MONTH,onQueryMonth);
			
			panelEngineAnalysisAverage.addEventListener(PanelEngineAnalysisAverage.EXPORT_DAY,onExportDay);
			panelEngineAnalysisAverage.addEventListener(PanelEngineAnalysisAverage.EXPORT_MONTH,onExportMonth);
		}
		
		override public function onRemove():void
		{			
			panelEngineAnalysisAverage.removeEventListener(PanelEngineAnalysisAverage.QUERY_DAY,onQueryDay);
			panelEngineAnalysisAverage.removeEventListener(PanelEngineAnalysisAverage.QUERY_MONTH,onQueryMonth);
						
			panelEngineAnalysisAverage.removeEventListener(PanelEngineAnalysisAverage.EXPORT_DAY,onExportDay);
			panelEngineAnalysisAverage.removeEventListener(PanelEngineAnalysisAverage.EXPORT_MONTH,onExportMonth);
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
					panelEngineAnalysisAverage.ropeway = RopewayVO(notification.getBody());
					break;
			}
		}			
				
		private function onExportDay(event:Event):void
		{
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = DeviceVO(panelEngineAnalysisAverage.rbgPos.selectedValue);
			notify.sTime = panelEngineAnalysisAverage.sTime;
			notify.eTime = panelEngineAnalysisAverage.eTime;
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_EXPORT_DAY,notify);			
		}			
		
		private function onExportMonth(event:Event):void
		{
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = DeviceVO(panelEngineAnalysisAverage.rbgPos.selectedValue);
			notify.sTime = panelEngineAnalysisAverage.sTime;
			notify.eTime = panelEngineAnalysisAverage.eTime;
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_EXPORT_MONTH,notify);			
		}
		
		private function onQueryDay(event:Event):void
		{			
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = DeviceVO(panelEngineAnalysisAverage.rbgPos.selectedValue);
			notify.sTime = panelEngineAnalysisAverage.sTime;
			notify.eTime = panelEngineAnalysisAverage.eTime;
			
			notify.ResultHandle = queryDayResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_QUERY_DAY,notify);
		}
		
		private function queryDayResultHandle(colEngineTemp:ArrayCollection):void
		{
			panelEngineAnalysisAverage.colEngineTemp = colEngineTemp;
		}
		
		private function onQueryMonth(event:Event):void
		{			
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = DeviceVO(panelEngineAnalysisAverage.rbgPos.selectedValue);
			notify.sTime = panelEngineAnalysisAverage.sTime;
			notify.eTime = panelEngineAnalysisAverage.eTime;
			
			notify.ResultHandle = queryMonthResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_QUERY_MONTH,notify);
		}
		
		private function queryMonthResultHandle(colEngineTemp:ArrayCollection):void
		{
			panelEngineAnalysisAverage.colEngineTemp = colEngineTemp;
		}
	}
}