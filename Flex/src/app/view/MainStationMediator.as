package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayVO;
	import app.view.components.MainStation;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Group;
	
	public class MainStationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainStationMediator";
		
		public function MainStationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			mainStation.addEventListener(MainStation.GROUP_CHANGE,onGroupChange);
			mainStation.addEventListener(MainStation.GROUP_ANALYSIS_CHANGE,onGroupAnalysisChange);
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
			sendNotification(ApplicationFacade.NOTIFY_MAIN_ANALYSIS_CHANGE,mainStation.rbgAnalysis.selectedValue);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,
				
				ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
				
				ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME,
				
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
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					mainStation.contentName = "实时监测";
					mainStation.config = notification.getBody() as ConfigVO;
					break;
				
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME:	
					updateCarCount();
					break;
				
				case ApplicationFacade.NOTIFY_MENU_REALTIME_DETECTION:
					mainStation.contentName = "实时监测";
					mainStation.gpAnalysis.visible = false;
					mainStation.gpStation.visible = true;
					break;
				
				case ApplicationFacade.NOTIFY_MENU_TODAY_OVERVIEW:	
					mainStation.contentName = "当天概览";
					mainStation.gpAnalysis.visible = false;
					mainStation.gpStation.visible = true;
					break;
				
				case ApplicationFacade.NOTIFY_MENU_ANALYSIS:	
					mainStation.contentName = "分析查询";
					mainStation.gpAnalysis.visible = true;
					mainStation.gpStation.visible = false;
					break;
				
				case ApplicationFacade.NOTIFY_MENU_MANAGE:	
					mainStation.contentName = "参数设置";
					mainStation.gpAnalysis.visible = false;
					mainStation.gpStation.visible = false;
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