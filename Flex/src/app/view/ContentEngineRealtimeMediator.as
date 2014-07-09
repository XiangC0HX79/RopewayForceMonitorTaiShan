package app.view
{
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.model.EngineProxy;
	import app.model.vo.EngineVO;
	import app.model.vo.RopewayVO;
	import app.view.components.ContentEngineRealtime;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ContentEngineRealtimeMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentEngineRealtimeMediator";
		
		public function ContentEngineRealtimeMediator()
		{ 
			super(NAME, new ContentEngineRealtime);
		}
		
		protected function get contentEngineTempRealtimeDetection():ContentEngineRealtime
		{
			return viewComponent as ContentEngineRealtime;
		}
		
		override public function onRegister():void
		{			
			contentEngineTempRealtimeDetection.addEventListener(FlexEvent.ADD,onMediatorAdd);
			contentEngineTempRealtimeDetection.addEventListener(FlexEvent.REMOVE,onMediatorRemove);
		}
		
		
		private function onMediatorAdd(event:FlexEvent):void
		{
			facade.registerMediator(new PanelEngineRealtimeTempFstMediator(contentEngineTempRealtimeDetection.panelTempFst));
			facade.registerMediator(new PanelEngineRealtimeTempSndMediator(contentEngineTempRealtimeDetection.panelTempSnd));
			facade.registerMediator(new PanelEngineRealtimeChartFstMediator(contentEngineTempRealtimeDetection.panelChartFst));
			facade.registerMediator(new PanelEngineRealtimeChartSndMediator(contentEngineTempRealtimeDetection.panelChartSnd));
		}
		
		private function onMediatorRemove(event:FlexEvent):void
		{
			facade.removeMediator(PanelEngineRealtimeTempFstMediator.NAME);
			facade.removeMediator(PanelEngineRealtimeTempSndMediator.NAME);
			facade.removeMediator(PanelEngineRealtimeChartFstMediator.NAME);
			facade.removeMediator(PanelEngineRealtimeChartSndMediator.NAME);
		}
		
	}
}