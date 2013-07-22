package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayAlarmAnalysisProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelAnalysisAlarm;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelAnalysisAlarmMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisAlarmMediator";
		
		private var _ropewayAlarmAnalysisProxy:RopewayAlarmAnalysisProxy;
		
		public function PanelAnalysisAlarmMediator()
		{
			super(NAME,new PanelAnalysisAlarm);
			
			panelAnalysisAlarm.addEventListener(PanelAnalysisAlarm.QUERY,onQuery);
			panelAnalysisAlarm.addEventListener(PanelAnalysisAlarm.STATION_CHANGE,onStationChange);
			
			_ropewayAlarmAnalysisProxy = facade.retrieveProxy(RopewayAlarmAnalysisProxy.NAME) as RopewayAlarmAnalysisProxy;
			panelAnalysisAlarm.colRopewayHis = _ropewayAlarmAnalysisProxy.colAlarm;
		}
		
		protected function get panelAnalysisAlarm():PanelAnalysisAlarm
		{
			return viewComponent as PanelAnalysisAlarm;
		}
		
		private function onStationChange(event:Event):void
		{			
			var station:String = String(panelAnalysisAlarm.rbgStation.selectedValue);
			changeStation(station);
		}
		
		private function onGetRopewayList(event:ResultEvent,t:Object):void
		{
			var arr:Array = [RopewayVO.ALL];
			for each(var o:ObjectProxy in event.result)
			{
				var rw:RopewayVO = new RopewayVO(o);
				arr.push(rw);
			}
			panelAnalysisAlarm.colRopeway = new ArrayCollection(arr);
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisAlarm.dateE.time < panelAnalysisAlarm.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}			
			var token:AsyncToken = _ropewayAlarmAnalysisProxy.GetAlarmCol(
				panelAnalysisAlarm.dateS
				,panelAnalysisAlarm.dateE
				,String(panelAnalysisAlarm.rbgStation.selectedValue)
				,panelAnalysisAlarm.listRopewayId.selectedItem.ropewayId
			);;
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
			
			panelAnalysisAlarm.colRopeway.source = arr;
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
					
					panelAnalysisAlarm.colStations = proxy.config.stations;	
					
					panelAnalysisAlarm.colRopeway.source = [RopewayVO.ALL];
					
					panelAnalysisAlarm.rbgStation.selectedValue = proxy.config.stations[0];
					
					changeStation(proxy.config.stations[0]);
					break;
			}
		}
	}
}