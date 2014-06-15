package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.EngineTempProxy;
	import app.model.dict.RopewayDict;
	import app.model.vo.EngineVO;
	import app.view.components.ContentEngineTempRealtimeDetection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ContentEngineTempRealtimeDetectionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentEngineTempRealtimeDetectionMediator";
		
		public function ContentEngineTempRealtimeDetectionMediator()
		{
			super(NAME, new ContentEngineTempRealtimeDetection);
			
			facade.registerMediator(new PanelEngineFirstTempRealtimeMediator(contentEngineTempRealtimeDetection.panelFst));
		}
		
		protected function get contentEngineTempRealtimeDetection():ContentEngineTempRealtimeDetection
		{
			return viewComponent as ContentEngineTempRealtimeDetection;
		}
	}
}