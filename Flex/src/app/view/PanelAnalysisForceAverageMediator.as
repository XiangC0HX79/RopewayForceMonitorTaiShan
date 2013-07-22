package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayForceAverageProxy;
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
			
			changeStation(station);
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisForceAverage.dateE.time < panelAnalysisForceAverage.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			panelAnalysisForceAverage.selectOne = (panelAnalysisForceAverage.listRopewayId.selectedItem.ropewayId != "所有抱索器");
			
			ropewayForceAverageProxy.GetForceAveCol(
				panelAnalysisForceAverage.dateS
				,panelAnalysisForceAverage.dateE
				,String(panelAnalysisForceAverage.rbgStation.selectedValue)
				,panelAnalysisForceAverage.listRopewayId.selectedItem.ropewayId
				,panelAnalysisForceAverage.comboTime.selectedIndex
				);
		}
		
		private function onSelectOne(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"图形只能显示单一吊箱的数据，请先选择吊箱编号统计再切换至图形。");
		}		
		
		private function changeStation(station:String):void
		{
			var arr:Array = [];
			if(station != "所有索道站")
			{
				var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
				for each(var r:RopewayVO in proxy.colRopeway)
				{
					if(r.ropewayStation == station)
					{
						arr.push(r);
					}
				}
			}
			
			arr.sortOn("ropewayCarId");
			
			arr.unshift(RopewayVO.ALL);
			
			panelAnalysisForceAverage.colRopeway.source = arr;
		}	
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					var proxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					
					panelAnalysisForceAverage.colStations = proxy.config.stations;	
					
					panelAnalysisForceAverage.colRopeway.source = [RopewayVO.ALL];
					
					panelAnalysisForceAverage.rbgStation.selectedValue = proxy.config.stations[0];
					
					changeStation(proxy.config.stations[0]);
					break;
			}
		}
	}
}