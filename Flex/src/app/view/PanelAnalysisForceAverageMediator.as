package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayForceAverageProxy;
	import app.model.RopewayListProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelAnalysisForceAverage;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelAnalysisForceAverageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisForceAverageMediator";
		
		private var ropewayForceAverageProxy:RopewayForceAverageProxy;
		
		public function PanelAnalysisForceAverageMediator()
		{
			super(NAME, new PanelAnalysisForceAverage);
			
			panelAnalysisForceAverage.addEventListener(PanelAnalysisForceAverage.QUERY,onQuery);
			panelAnalysisForceAverage.addEventListener(PanelAnalysisForceAverage.STATION_CHANGE,onStationChange);
			panelAnalysisForceAverage.addEventListener(PanelAnalysisForceAverage.SELECT_ONE,onSelectOne);
			
			ropewayForceAverageProxy = facade.retrieveProxy(RopewayForceAverageProxy.NAME) as RopewayForceAverageProxy;
			panelAnalysisForceAverage.colRopewayHis = ropewayForceAverageProxy.col;
		}
		
		protected function get panelAnalysisForceAverage():PanelAnalysisForceAverage
		{
			return viewComponent as PanelAnalysisForceAverage;
		}
		
		private function onStationChange(event:Event):void
		{
			var station:String = String(panelAnalysisForceAverage.rbgStation.selectedValue);
			
			var arr:Array = [RopewayVO.ALL];
			if(station != "所有索道站")
			{
				var proxy:RopewayListProxy = facade.retrieveProxy(RopewayListProxy.NAME) as RopewayListProxy;
				for each(var r:RopewayVO in proxy.colRopeway)
				{
					if(r.ropewayStation == station)
					{
						arr.push(r);
					}
				}
			}
			panelAnalysisForceAverage.colRopeway.source = arr;
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisForceAverage.dateE.time < panelAnalysisForceAverage.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			ropewayForceAverageProxy.GetForceAveCol(
				panelAnalysisForceAverage.dateS
				,panelAnalysisForceAverage.dateE
				,String(panelAnalysisForceAverage.rbgStation.selectedValue)
				,String(panelAnalysisForceAverage.listRopewayId.selectedItem)
				,panelAnalysisForceAverage.comboTime.selectedIndex
				);
		}
		
		private function onSelectOne(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"图形只能显示单一吊箱的数据，请先选择吊箱编号再切换至图形。");
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
					panelAnalysisForceAverage.colStations = config.stations;	
					
					panelAnalysisForceAverage.colRopeway.source = [RopewayVO.ALL];
					break;
			}
		}
	}
}