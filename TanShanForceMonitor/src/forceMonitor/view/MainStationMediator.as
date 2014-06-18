package forceMonitor.view
{
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.model.ConfigProxy;
	import forceMonitor.model.RopewayProxy;
	import forceMonitor.model.vo.ConfigVO;
	import forceMonitor.model.vo.RopewayVO;
	import forceMonitor.view.components.MainStation;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	import spark.components.Group;
	
	public class MainStationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainStationMediator";
		
		public function MainStationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			mainStation.addEventListener(MainStation.GROUP_CHANGE,onGroupChange);
			mainStation.addEventListener(MainStation.GROUP_ANALYSIS_CHANGE,onGroupAnalysisChange);
			mainStation.addEventListener(MainStation.GROUP_MANAGER_CHANGE,onGroupMangerChange);
		}
		
		protected function get mainStation():MainStation
		{
			return viewComponent as MainStation;
		}
		
		private function onGroupChange(event:Event):void
		{			
			updateCarCount();
			
			sendNotification(ForceMonitorFacade.NOTIFY_MAIN_STATION_CHANGE,mainStation.config.station);
		}
		
		private function onGroupAnalysisChange(event:Event):void
		{						
			var index:Number = mainStation.gpAnalysis.getElementIndex(mainStation.rbgAnalysis.selection);
			sendNotification(ForceMonitorFacade.NOTIFY_MAIN_ANALYSIS_CHANGE,index);
		}
		
		private function onGroupMangerChange(event:Event):void
		{						
			var index:Number = mainStation.gpManager.getElementIndex(mainStation.rbgManager.selection);
			sendNotification(ForceMonitorFacade.NOTIFY_MAIN_MANAGER_CHANGE,index);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ForceMonitorFacade.NOTIFY_INIT_CONFIG_COMPLETE,
				
				ForceMonitorFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
				
				ForceMonitorFacade.NOTIFY_ROPEWAY_INFO_REALTIME,
				
				ForceMonitorFacade.NOTIFY_MENU_REALTIME_DETECTION,
				
				ForceMonitorFacade.NOTIFY_MENU_TODAY_OVERVIEW,
				
				ForceMonitorFacade.NOTIFY_MENU_ANALYSIS,
				
				ForceMonitorFacade.NOTIFY_MENU_MANAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ForceMonitorFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					mainStation.contentName = "实时监测";
					mainStation.config = notification.getBody() as ConfigVO;
					break;
				
				case ForceMonitorFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:
				case ForceMonitorFacade.NOTIFY_ROPEWAY_INFO_REALTIME:	
					updateCarCount();
					break;
				
				case ForceMonitorFacade.NOTIFY_MENU_REALTIME_DETECTION:
					mainStation.contentName = "实时监测";
					mainStation.gpAnalysis.visible = false;
					mainStation.gpStation.visible = true;
					mainStation.gpManager.visible = false;
					break;
				
				case ForceMonitorFacade.NOTIFY_MENU_TODAY_OVERVIEW:	
					mainStation.contentName = "当天概览";
					mainStation.gpAnalysis.visible = false;
					mainStation.gpStation.visible = true;
					mainStation.gpManager.visible = false;
					break;
				
				case ForceMonitorFacade.NOTIFY_MENU_ANALYSIS:	
					mainStation.contentName = "分析查询";
					mainStation.gpAnalysis.visible = true;
					mainStation.gpStation.visible = false;
					mainStation.gpManager.visible = false;
					break;
				
				case ForceMonitorFacade.NOTIFY_MENU_MANAGE:	
					mainStation.contentName = "参数设置";
					mainStation.gpAnalysis.visible = false;
					mainStation.gpStation.visible = false;
					mainStation.gpManager.visible = true;
					break;
			}
		}
		
		private function updateCarCount():void
		{
			var ropewayProxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			mainStation.carCount = ropewayProxy.GetRopewayCount(mainStation.config.station);
		}
	}
}