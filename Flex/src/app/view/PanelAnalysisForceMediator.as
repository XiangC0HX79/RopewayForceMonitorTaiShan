package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayForceProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelAnalysisForce;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelAnalysisForceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisForceMediator";
		
		public function PanelAnalysisForceMediator()
		{
			super(NAME, new PanelAnalysisForce);
			
			panelAnalysisForce.addEventListener(PanelAnalysisForce.QUERY,onQuery);
			panelAnalysisForce.addEventListener(PanelAnalysisForce.STATION_CHANGE,onStationChange);
		}
		
		protected function get panelAnalysisForce():PanelAnalysisForce
		{
			return viewComponent as PanelAnalysisForce;
		}
		
		private function onStationChange(event:Event):void
		{
			var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			var token:AsyncToken = proxy.getRopewayList(String(panelAnalysisForce.rbgStation.selectedValue));
			token.addResponder(new Responder(onGetRopewayList,function(falut:FaultEvent):void{}));
		}
		
		private function onGetRopewayList(event:ResultEvent):void
		{
			var arr1:Array = ["所有吊箱"];
			var arr2:Array = ["所有抱索器"];
			for each(var o:ObjectProxy in event.result)
			{
				var rw:RopewayVO = new RopewayVO(o);
				arr1.push(rw.ropewayCarId);
				arr2.push(rw.ropewayId);
			}
			panelAnalysisForce.colRopewayCarId = new ArrayCollection(arr1);
			panelAnalysisForce.colRopewayId = new ArrayCollection(arr2);
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisForce.dateE.time <= panelAnalysisForce.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			var proxy:RopewayForceProxy = facade.retrieveProxy(RopewayForceProxy.NAME) as RopewayForceProxy;
			if(panelAnalysisForce.comboTime.selectedIndex == 0)
			{				
				var token:AsyncToken = proxy.GetForceHistory(
					panelAnalysisForce.dateS
					,panelAnalysisForce.dateE
					,String(panelAnalysisForce.rbgStation.selectedValue)
					,String(panelAnalysisForce.listRopewayId.selectedItem)
					);
				token.addResponder(new Responder(onGetForceHistory,function(falut:FaultEvent):void{}));
			}
		}
		
		private function onGetForceHistory(event:ResultEvent):void
		{
			
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
					panelAnalysisForce.colStations = config.stations;	
					
					var arr1:Array = ["所有吊箱"];
					var arr2:Array = ["所有抱索器"];
					panelAnalysisForce.colRopewayCarId = new ArrayCollection(arr1);
					panelAnalysisForce.colRopewayId = new ArrayCollection(arr2);
					break;
			}
		}
	}
}