package app.view
{
	import com.adobe.utils.DateUtil;
	
	import app.ApplicationFacade;
	import app.model.EngineTempProxy;
	import app.model.dict.RopewayDict;
	import app.model.vo.EngineVO;
	import app.view.components.PanelEngineTempRealtime;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelEngineFirstTempRealtimeMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelEngineFirstTempRealtimeMediator";
		
		public function PanelEngineFirstTempRealtimeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelEngineTempRealtime():PanelEngineTempRealtime
		{
			return viewComponent as PanelEngineTempRealtime;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				
				ApplicationFacade.NOTIFY_ROPEWAY_CHANGE,
				
				ApplicationFacade.NOTIFY_SOCKET_ENGINE_TEMP
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{	
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:					
					var now:Date = new Date;
					var tom:Date = DateUtil.addDateTime('d',1,now);
					panelEngineTempRealtime.minTime = new Date(now.fullYear,now.month,now.date,22); 
					panelEngineTempRealtime.maxTime = new Date(now.fullYear,now.month,now.date,23);
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_CHANGE:
					var rw:RopewayDict = notification.getBody() as RopewayDict;
					
					var engineTempProxy:EngineTempProxy = facade.retrieveProxy(EngineTempProxy.NAME) as EngineTempProxy;
					panelEngineTempRealtime.engine = engineTempProxy.getEngine(rw,EngineVO.FIRST);
					break;
				
				case ApplicationFacade.NOTIFY_SOCKET_ENGINE_TEMP:
					var engine:EngineVO = notification.getBody() as EngineVO;
					
					if(panelEngineTempRealtime.engine == engine)
					{
						panelEngineTempRealtime.engine = engine;
					}
					break;
			}
		}		
	}
}