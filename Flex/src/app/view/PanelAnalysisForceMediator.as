package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayForceProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelAnalysisForce;
	
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
	
	public class PanelAnalysisForceMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelAnalysisForceMediator";
		
		public function PanelAnalysisForceMediator()
		{
			super(NAME, new PanelAnalysisForce);
			
			panelAnalysisForce.addEventListener(PanelAnalysisForce.QUERY,onQuery);
			panelAnalysisForce.addEventListener(PanelAnalysisForce.STATION_CHANGE,onStationChange);
			panelAnalysisForce.addEventListener(PanelAnalysisForce.SELECT_ONE,onSelectOne);
			
			var ropewayForceProxy:RopewayForceProxy = facade.retrieveProxy(RopewayForceProxy.NAME) as RopewayForceProxy;
			panelAnalysisForce.colRopewayHis = ropewayForceProxy.col;
		}
		
		protected function get panelAnalysisForce():PanelAnalysisForce
		{
			return viewComponent as PanelAnalysisForce;
		}
		
		private function onStationChange(event:Event):void
		{
			var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			var token:AsyncToken = proxy.getRopewayList(String(panelAnalysisForce.rbgStation.selectedValue));
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
			panelAnalysisForce.colRopewayCarId = new ArrayCollection(arr1);
			panelAnalysisForce.colRopewayId = new ArrayCollection(arr2);
		}
		
		private function onQuery(event:Event):void
		{
			if(panelAnalysisForce.dateE.time < panelAnalysisForce.dateS.time)
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询时间段结束时间不能小于开始时间。");
				return;
			}
			
			var temp1:Number = Number(panelAnalysisForce.numTempMin.text);
			var temp2:Number = Number(panelAnalysisForce.numTempMax.text);
			if(isNaN(temp1) || isNaN(temp2))
			{
				sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"请输入正确的查询温度值。");
				return;
			}
			
			if((panelAnalysisForce.numTempMin.text != "") && (panelAnalysisForce.numTempMax.text != ""))
			{
				if(temp2 < temp1)
				{					
					sendNotification(ApplicationFacade.NOTIFY_ALERT_ALARM,"查询最高温度不能小于最低温度。");
					return;
				}
			}
			
			var proxy:RopewayForceProxy = facade.retrieveProxy(RopewayForceProxy.NAME) as RopewayForceProxy;
			var token:AsyncToken = proxy.GetForceHistory(
				panelAnalysisForce.dateS
				,panelAnalysisForce.dateE
				,String(panelAnalysisForce.rbgStation.selectedValue)
				,String(panelAnalysisForce.listRopewayId.selectedItem)
				,panelAnalysisForce.numTempMin.text
				,panelAnalysisForce.numTempMax.text
				);;
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