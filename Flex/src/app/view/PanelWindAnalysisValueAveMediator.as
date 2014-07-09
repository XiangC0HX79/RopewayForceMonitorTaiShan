package app.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.notify.NotifyWindAnalysisValueVO;
	import app.model.vo.BracketVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelWindAnalysisValueAve;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelWindAnalysisValueAveMediator extends Mediator
	{
		public static const NAME:String = "PanelWindAnalysisValueAveMediator";
		
		public function PanelWindAnalysisValueAveMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelWindAnalysisValue():PanelWindAnalysisValueAve
		{
			return viewComponent as PanelWindAnalysisValueAve;
		}
		
		override public function onRegister():void
		{
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisValueAve.SELECT_ONE,onSelectOne);
						
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisValueAve.QUERY,onQuery);
			panelWindAnalysisValue.addEventListener(PanelWindAnalysisValueAve.EXPORT,onExport);
		}
		
		override public function onRemove():void
		{
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisValueAve.SELECT_ONE,onSelectOne);
			
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisValueAve.QUERY,onQuery);
			panelWindAnalysisValue.removeEventListener(PanelWindAnalysisValueAve.EXPORT,onExport);
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
		
		private function onQuery(event:Event):void
		{			
			var notify:NotifyWindAnalysisValueVO = new NotifyWindAnalysisValueVO;
			notify.bracket = BracketVO(panelWindAnalysisValue.listBracket.selectedItem);
			notify.sTime = panelWindAnalysisValue.sTime;
			notify.eTime = panelWindAnalysisValue.eTime;
			
			notify.ResultHandle = queryResultHandle;
			
			sendNotification(ApplicationFacade.NOTIFY_WIND_AVERAGE_QUERY,notify);
		}
		
		private function queryResultHandle(colWindAve:ArrayCollection):void
		{
			panelWindAnalysisValue.colWindAve = colWindAve;
		}
	}
}