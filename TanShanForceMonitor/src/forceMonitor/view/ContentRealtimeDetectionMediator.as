package forceMonitor.view
{
	import mx.collections.ArrayCollection;
	import mx.core.IVisualElement;
	import mx.formatters.DateFormatter;
	
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.model.RopewayAlarmProxy;
	import forceMonitor.model.RopewayProxy;
	import forceMonitor.model.vo.RopewayAlarmVO;
	import forceMonitor.model.vo.RopewayVO;
	import forceMonitor.view.components.ContentRealtimeDetection;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ContentRealtimeDetectionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentRealtimeDetectionMediator";
		
		public function ContentRealtimeDetectionMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function onRegister():void
		{														
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