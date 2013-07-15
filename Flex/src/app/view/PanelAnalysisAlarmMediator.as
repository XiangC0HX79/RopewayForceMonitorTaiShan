package app.view
{
	import app.ApplicationFacade;
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
			var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			var token:AsyncToken = proxy.getRopewayList(String(panelAnalysisAlarm.rbgStation.selectedValue));
			token.addResponder(new AsyncResponder(onGetRopewayList,null));
		}
		
		private function onGetRopewayList(event:ResultEvent,t:Object):void
		{
			var arr1:Array = ["所有吊箱"];
			var arr2:Array = ["所有抱索器"];
			for each(var o:ObjectProxy in event.result)
			{
				var rw:RopewayVO = new RopewayVO(o);
				arr1.push(rw.ropewayCarId);
				arr2.push(rw.ropewayId);
			}
			panelAnalysisAlarm.colRopewayCarId = new ArrayCollection(arr1);
			panelAnalysisAlarm.colRopewayId = new ArrayCollection(arr2);
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
				,String(panelAnalysisAlarm.listRopewayId.selectedItem)
			);;
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
					panelAnalysisAlarm.colStations = config.stations;	
					
					var arr1:Array = ["所有吊箱"];
					var arr2:Array = ["所有抱索器"];
					panelAnalysisAlarm.colRopewayCarId = new ArrayCollection(arr1);
					panelAnalysisAlarm.colRopewayId = new ArrayCollection(arr2);
					break;
			}
		}
	}
}