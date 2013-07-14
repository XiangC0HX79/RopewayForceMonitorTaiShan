package app.view
{
	import app.ApplicationFacade;
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
		
		public function PanelAnalysisForceAverageMediator()
		{
			super(NAME, new PanelAnalysisForceAverage);
			
			panelAnalysisForceAverage.addEventListener(PanelAnalysisForceAverage.QUERY,onQuery);
			panelAnalysisForceAverage.addEventListener(PanelAnalysisForceAverage.STATION_CHANGE,onStationChange);
			panelAnalysisForceAverage.addEventListener(PanelAnalysisForceAverage.SELECT_ONE,onSelectOne);
		}
		
		protected function get panelAnalysisForceAverage():PanelAnalysisForceAverage
		{
			return viewComponent as PanelAnalysisForceAverage;
		}
		
		private function onStationChange(event:Event):void
		{
			var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			var token:AsyncToken = proxy.getRopewayList(String(panelAnalysisForceAverage.rbgStation.selectedValue));
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
			panelAnalysisForceAverage.colRopewayCarId = new ArrayCollection(arr1);
			panelAnalysisForceAverage.colRopewayId = new ArrayCollection(arr2);
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisForceAverage.dateE.time < panelAnalysisForceAverage.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			var proxy:RopewayForceAverageProxy = facade.retrieveProxy(RopewayForceAverageProxy.NAME) as RopewayForceAverageProxy;
			proxy.GetForceAveCol(
				panelAnalysisForceAverage.dateS
				,panelAnalysisForceAverage.dateE
				,String(panelAnalysisForceAverage.rbgStation.selectedValue)
				,String(panelAnalysisForceAverage.listRopewayId.selectedItem)
				);
		}
		
		private function onGetForceHistory(event:ResultEvent,t:Object):void
		{
			var arr:Array = [];
			for each(var o:ObjectProxy in event.result)
			{
				arr.push(new RopewayForceVO(o));
			}
			panelAnalysisForceAverage.colRopewayHis = new ArrayCollection(arr);
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
					
					var arr1:Array = ["所有吊箱"];
					var arr2:Array = ["所有抱索器"];
					panelAnalysisForceAverage.colRopewayCarId = new ArrayCollection(arr1);
					panelAnalysisForceAverage.colRopewayId = new ArrayCollection(arr2);
					break;
			}
		}
	}
}