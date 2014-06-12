package app.view
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Group;
	
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.MainStation;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainStationMediator_Old extends Mediator implements IMediator
	{
		public static const NAME:String = "MainStationMediator";
		
		public function MainStationMediator_Old(viewComponent:Object=null)
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
			
			sendNotification(ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE,mainStation.config.station);
		}
		
		private function onGroupAnalysisChange(event:Event):void
		{						
			var index:Number = mainStation.gpAnalysis.getElementIndex(mainStation.rbgAnalysis.selection);
			sendNotification(ApplicationFacade.NOTIFY_MAIN_ANALYSIS_CHANGE,index);
		}
		
		private function onGroupMangerChange(event:Event):void
		{						
			var index:Number = mainStation.gpManager.getElementIndex(mainStation.rbgManager.selection);
			sendNotification(ApplicationFacade.NOTIFY_MAIN_MANAGER_CHANGE,index);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
								
				//ApplicationFacade.NOTIFY_SOCKET_FORCE,
				
				ApplicationFacade.NOTIFY_MENU_REALTIME_DETECTION,
				
				ApplicationFacade.NOTIFY_MENU_TODAY_OVERVIEW,
				
				ApplicationFacade.NOTIFY_MENU_ANALYSIS,
				
				ApplicationFacade.NOTIFY_MENU_MANAGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					mainStation.contentName = "实时监测";
					
					var config:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					mainStation.config = config.config;
					
					updateCarCount();
					break;
				
				//case ApplicationFacade.NOTIFY_SOCKET_FORCE:	
				//	updateCarCount();
				//	break;
				
				case ApplicationFacade.NOTIFY_MENU_REALTIME_DETECTION:
					mainStation.contentName = "实时监测";
					mainStation.gpAnalysis.visible = false;
					mainStation.gpStation.visible = true;
					mainStation.gpManager.visible = false;
					break;
				
				case ApplicationFacade.NOTIFY_MENU_TODAY_OVERVIEW:	
					mainStation.contentName = "当天概览";
					mainStation.gpAnalysis.visible = false;
					mainStation.gpStation.visible = true;
					mainStation.gpManager.visible = false;
					break;
				
				case ApplicationFacade.NOTIFY_MENU_ANALYSIS:	
					mainStation.contentName = "分析查询";
					mainStation.gpAnalysis.visible = true;
					mainStation.gpStation.visible = false;
					mainStation.gpManager.visible = false;
					break;
				
				case ApplicationFacade.NOTIFY_MENU_MANAGE:	
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