package app.view
{
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.EngineTempProxy;
	import app.model.dict.RopewayDict;
	import app.model.vo.EngineVO;
	import app.view.components.ContentEngineTempRealtime;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ContentEngineTempRealtimeDetectionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentEngineTempRealtimeDetectionMediator";
		
		public function ContentEngineTempRealtimeDetectionMediator()
		{ 
			super(NAME, new ContentEngineTempRealtime);
		}
		
		protected function get contentEngineTempRealtimeDetection():ContentEngineTempRealtime
		{
			return viewComponent as ContentEngineTempRealtime;
		}
		
		private function onMediatorAdd(event:FlexEvent):void
		{
			facade.registerMediator(new PanelEngineFirstTempRealtimeMediator(contentEngineTempRealtimeDetection.panelFst));
			
			//sendNotification(ApplicationFacade.NOTIFY_ENGINE_REALTIME_ADD)
		}
		
		private function onMediatorRemove(event:FlexEvent):void
		{
			facade.removeMediator(PanelEngineFirstTempRealtimeMediator.NAME);
		}
		
	}
}