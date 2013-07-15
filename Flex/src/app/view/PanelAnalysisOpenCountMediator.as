package app.view
{
	import app.ApplicationFacade;
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
			var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			var token:AsyncToken = proxy.getRopewayList(String(panelAnalysisOpenCount.rbgStation.selectedValue));
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
			panelAnalysisOpenCount.colRopewayCarId = new ArrayCollection(arr1);
			panelAnalysisOpenCount.colRopewayId = new ArrayCollection(arr2);
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisOpenCount.dateE.time < panelAnalysisOpenCount.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			_ropewaySwitchFreqProxy.GetSwitchFreqCol(
				panelAnalysisOpenCount.dateS
				,panelAnalysisOpenCount.dateE
				,String(panelAnalysisOpenCount.rbgStation.selectedValue)
				,String(panelAnalysisOpenCount.listRopewayId.selectedItem)
				,panelAnalysisOpenCount.comboTime.selectedIndex
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
					panelAnalysisOpenCount.colStations = config.stations;	
					
					var arr1:Array = ["所有吊箱"];
					var arr2:Array = ["所有抱索器"];
					panelAnalysisOpenCount.colRopewayCarId = new ArrayCollection(arr1);
					panelAnalysisOpenCount.colRopewayId = new ArrayCollection(arr2);
					break;
			}
		}
	}
}