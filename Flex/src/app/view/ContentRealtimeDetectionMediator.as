package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayAlarmProxy;
	import app.model.vo.RopewayAlarmVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.ContentRealtimeDetection;
	
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;
	import mx.formatters.DateFormatter;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ContentRealtimeDetectionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentRealtimeDetectionMediator";
		
		public function ContentRealtimeDetectionMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			facade.registerMediator(new PanelRopewayForceMediator(contentRealtimeDetection.panelForce));
			
			facade.registerMediator(new PanelRopewayTempMediator(contentRealtimeDetection.panelTemp));
			
			facade.registerMediator(new PanelRopewayAlarmMediator(contentRealtimeDetection.panelAlarm));
		}
		
		protected function get contentRealtimeDetection():ContentRealtimeDetection
		{
			return viewComponent as ContentRealtimeDetection;
		}
	}
}