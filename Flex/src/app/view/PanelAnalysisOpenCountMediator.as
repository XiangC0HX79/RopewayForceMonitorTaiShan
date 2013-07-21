package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.RopewaySwitchFreqProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelAnalysisOpenCount;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelAnalysisOpenCountMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisOpenCountMediator";
		
		private var _ropewaySwitchFreqProxy:RopewaySwitchFreqProxy;
		
		public function PanelAnalysisOpenCountMediator()
		{
			super(NAME, new PanelAnalysisOpenCount);
			
			panelAnalysisOpenCount.addEventListener(PanelAnalysisOpenCount.QUERY,onQuery);
			panelAnalysisOpenCount.addEventListener(PanelAnalysisOpenCount.STATION_CHANGE,onStationChange);
			panelAnalysisOpenCount.addEventListener(PanelAnalysisOpenCount.SELECT_ONE,onSelectOne);
			
			_ropewaySwitchFreqProxy = facade.retrieveProxy(RopewaySwitchFreqProxy.NAME) as RopewaySwitchFreqProxy;
			panelAnalysisOpenCount.colSwitchFreq = _ropewaySwitchFreqProxy.colSwitchFreq;
		}
		
		protected function get panelAnalysisOpenCount():PanelAnalysisOpenCount
		{
			return viewComponent as PanelAnalysisOpenCount;
		}
		
		private function onStationChange(event:Event):void
		{
			var station:String = String(panelAnalysisOpenCount.rbgStation.selectedValue);
			
			var arr:Array = [RopewayVO.ALL];
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
			panelAnalysisOpenCount.colRopeway.source = arr;
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisOpenCount.dateE.time < panelAnalysisOpenCount.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			panelAnalysisOpenCount.selectOne = (panelAnalysisOpenCount.listRopewayId.selectedItem.ropewayId != "所有抱索器");
			
			_ropewaySwitchFreqProxy.GetSwitchFreqCol(
				panelAnalysisOpenCount.dateS
				,panelAnalysisOpenCount.dateE
				,String(panelAnalysisOpenCount.rbgStation.selectedValue)
				,panelAnalysisOpenCount.listRopewayId.selectedItem.ropewayId
				,panelAnalysisOpenCount.comboTime.selectedIndex
			);
		}
		
		private function onSelectOne(event:Event):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"图形只能显示单一吊箱的数据，请先选择吊箱编号再切换至图形。");
		}			
		
		private function changeStation(station:String):void
		{
			var arr:Array = [RopewayVO.ALL];
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
			panelAnalysisOpenCount.colRopeway.source = arr;
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
					
					panelAnalysisOpenCount.colStations = proxy.config.stations;	
					
					panelAnalysisOpenCount.colRopeway.source = [RopewayVO.ALL];
					
					panelAnalysisOpenCount.rbgStation.selectedValue = proxy.config.stations[0];
					
					changeStation(proxy.config.stations[0]);
					break;
			}
		}
	}
}