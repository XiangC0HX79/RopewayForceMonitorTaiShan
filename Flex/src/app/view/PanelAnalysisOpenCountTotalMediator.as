package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewaySwitchFreqTotalProxy;
	import app.model.vo.ConfigVO;
	import app.view.components.PanelAnalysisOpenCountTotal;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelAnalysisOpenCountTotalMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisOpenCountTotalMediator";
		
		private var _ropewaySwitchFreqTotalProxy:RopewaySwitchFreqTotalProxy;
		
		public function PanelAnalysisOpenCountTotalMediator()
		{
			super(NAME, new PanelAnalysisOpenCountTotal);
			
			panelAnalysisOpenCountTotal.addEventListener(PanelAnalysisOpenCountTotal.QUERY,onQuery);
			
			_ropewaySwitchFreqTotalProxy = facade.retrieveProxy(RopewaySwitchFreqTotalProxy.NAME) as RopewaySwitchFreqTotalProxy;
			panelAnalysisOpenCountTotal.colRopeway = _ropewaySwitchFreqTotalProxy.colSwitchFreq;
		}
		
		protected function get panelAnalysisOpenCountTotal():PanelAnalysisOpenCountTotal
		{
			return viewComponent as PanelAnalysisOpenCountTotal;
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisOpenCountTotal.checkDatetime.selected
				&& (panelAnalysisOpenCountTotal.dateE.time < panelAnalysisOpenCountTotal.dateS.time))
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			_ropewaySwitchFreqTotalProxy.GetSwitchFreqCol(
				panelAnalysisOpenCountTotal.dateS
				,panelAnalysisOpenCountTotal.dateE
				,String(panelAnalysisOpenCountTotal.rbgStation.selectedValue)
				,panelAnalysisOpenCountTotal.checkDatetime.selected
			);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					var config:ConfigVO = notification.getBody() as ConfigVO;	
					
					panelAnalysisOpenCountTotal.colStations = config.stations;	
					
					panelAnalysisOpenCountTotal.rbgStation.selectedValue = config.stations[0];
					break;
			}
		}
	}
}