package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.EngineTempProxy;
	import app.model.vo.EngineVO;
	import app.view.components.ContentEngineTempRealtimeDetection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ContentEngineTempRealtimeDetectionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentEngineTempRealtimeDetectionMediator";
		
		private var engineTempProxy:EngineTempProxy;
		
		private var configProxy:ConfigProxy;
		
		public function ContentEngineTempRealtimeDetectionMediator()
		{
			super(NAME, new ContentEngineTempRealtimeDetection);
			
			configProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
				
			engineTempProxy = facade.retrieveProxy(EngineTempProxy.NAME) as EngineTempProxy;
		}
		
		protected function get contentEngineTempRealtimeDetection():ContentEngineTempRealtimeDetection
		{
			return viewComponent as ContentEngineTempRealtimeDetection;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_ROPEWAY_CHANGE,
				
				ApplicationFacade.NOTIFY_SOCKET_ENGINE_TEMP
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{	
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_ROPEWAY_CHANGE:
					var e:EngineVO = engineTempProxy.getEngine(configProxy.config.ropeway,EngineVO.FIRST);
					
					contentEngineTempRealtimeDetection.fstHistory = e.history;
					
					contentEngineTempRealtimeDetection.fstEngineTemp = e.lastTemp;
					
					e = engineTempProxy.getEngine(configProxy.config.ropeway,EngineVO.SECOND);
					
					contentEngineTempRealtimeDetection.sndHistory = e.history;
					
					contentEngineTempRealtimeDetection.sndEngineTemp = e.lastTemp;
					break;
				
				case ApplicationFacade.NOTIFY_SOCKET_ENGINE_TEMP:
					e = notification.getBody() as EngineVO;
					if(e.ropeway == configProxy.config.ropeway)
					{
						if(e.pos == EngineVO.FIRST)
							contentEngineTempRealtimeDetection.fstEngineTemp = e.lastTemp;
						else if(e.pos == EngineVO.SECOND)
							contentEngineTempRealtimeDetection.sndEngineTemp = e.lastTemp;
					}
					break;
			}
		}		
	}
}