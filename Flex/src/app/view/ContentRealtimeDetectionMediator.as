package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayAlarmProxy;
	import app.model.vo.RopewayAlarmVO;
	import app.model.vo.RopewayVO;
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
			
			contentRealtimeDetection.groupTop.addElement(facade.retrieveMediator(PanelRopewayCarIdMediator.NAME).getViewComponent() as IVisualElement);
			contentRealtimeDetection.groupTop.addElement(facade.retrieveMediator(PanelRopewayForceMediator.NAME).getViewComponent() as IVisualElement);
			contentRealtimeDetection.groupTop.addElement(facade.retrieveMediator(PanelRopewayTempMediator.NAME).getViewComponent() as IVisualElement);
			contentRealtimeDetection.groupTop.addElement(facade.retrieveMediator(PanelRopewayAlarmMediator.NAME).getViewComponent() as IVisualElement);
			
			contentRealtimeDetection.addElement(facade.retrieveMediator(ChartRealtimeDetectionMediator.NAME).getViewComponent() as IVisualElement);
		}
		
		protected function get contentRealtimeDetection():ContentRealtimeDetection
		{
			return viewComponent as ContentRealtimeDetection;
		}
	}
}