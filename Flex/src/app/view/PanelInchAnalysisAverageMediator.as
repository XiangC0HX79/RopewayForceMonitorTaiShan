package app.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.controller.notify.AnalysisNotify;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelInchAnalysisAverage;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelInchAnalysisAverageMediator extends Mediator
	{
		public static const NAME:String = "PanelInchAnalysisAverageMediator";
		
		public function PanelInchAnalysisAverageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelInchAnalysisAverage():PanelInchAnalysisAverage
		{
			return viewComponent as PanelInchAnalysisAverage;
		}
		
		override public function onRegister():void
		{						
			panelInchAnalysisAverage.addEventListener(PanelInchAnalysisAverage.QUERY_DAY,onQueryDay);
			panelInchAnalysisAverage.addEventListener(PanelInchAnalysisAverage.QUERY_MONTH,onQueryMonth);
			
			panelInchAnalysisAverage.addEventListener(PanelInchAnalysisAverage.EXPORT_DAY,onExportDay);
			panelInchAnalysisAverage.addEventListener(PanelInchAnalysisAverage.EXPORT_MONTH,onExportMonth);
		}
		
		override public function onRemove():void
		{			
			panelInchAnalysisAverage.removeEventListener(PanelInchAnalysisAverage.QUERY_DAY,onQueryDay);
			panelInchAnalysisAverage.removeEventListener(PanelInchAnalysisAverage.QUERY_MONTH,onQueryMonth);
						
			panelInchAnalysisAverage.removeEventListener(PanelInchAnalysisAverage.EXPORT_DAY,onExportDay);
			panelInchAnalysisAverage.removeEventListener(PanelInchAnalysisAverage.EXPORT_MONTH,onExportMonth);
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
					panelInchAnalysisAverage.inch = RopewayVO(notification.getBody()).inch;
					break;
			}
		}			
				
		private function onExportDay(event:Event):void
		{
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = panelInchAnalysisAverage.inch;
			notify.sTime = panelInchAnalysisAverage.sTime;
			notify.eTime = panelInchAnalysisAverage.eTime;
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_EXPORT_DAY,notify);			
		}			
		
		private function onExportMonth(event:Event):void
		{
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = panelInchAnalysisAverage.inch;
			notify.sTime = panelInchAnalysisAverage.sTime;
			notify.eTime = panelInchAnalysisAverage.eTime;
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_EXPORT_MONTH,notify);			
		}
		
		private function onQueryDay(event:Event):void
		{			
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = panelInchAnalysisAverage.inch;
			notify.sTime = panelInchAnalysisAverage.sTime;
			notify.eTime = panelInchAnalysisAverage.eTime;
			
			notify.ResultHandle = queryDayResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_QUERY_DAY,notify);
		}
		
		private function queryDayResultHandle(colInchValue:ArrayCollection):void
		{
			panelInchAnalysisAverage.colInchValue = colInchValue;
		}
		
		private function onQueryMonth(event:Event):void
		{			
			var notify:AnalysisNotify = new AnalysisNotify;
			notify.device = panelInchAnalysisAverage.inch;
			notify.sTime = panelInchAnalysisAverage.sTime;
			notify.eTime = panelInchAnalysisAverage.eTime;
			
			notify.ResultHandle = queryMonthResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_AVERAGE_QUERY_MONTH,notify);
		}
		
		private function queryMonthResultHandle(colInchValue:ArrayCollection):void
		{
			panelInchAnalysisAverage.colInchValue = colInchValue;
		}
	}
}