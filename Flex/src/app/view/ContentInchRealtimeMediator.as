package app.view
{
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.view.components.ContentInchRealtime;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ContentInchRealtimeMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentInchRealtimeMediator";
		
		public function ContentInchRealtimeMediator()
		{
			super(NAME, new ContentInchRealtime);
				
			contentInchRealtime.addEventListener(FlexEvent.ADD,onMediatorAdd);
			contentInchRealtime.addEventListener(FlexEvent.REMOVE,onMediatorRemove);
		}
		
		protected function get contentInchRealtime():ContentInchRealtime
		{
			return viewComponent as ContentInchRealtime;
		}
		
		private function onMediatorAdd(event:FlexEvent):void
		{
			facade.registerMediator(new PanelInchRealtimeTempMediator(contentInchRealtime.panelTemp));
			facade.registerMediator(new PanelInchRealtimeValueMediator(contentInchRealtime.panelValue));
			facade.registerMediator(new PanelInchRealtimeAlarmMediator(contentInchRealtime.panelAlarm));
			facade.registerMediator(new PanelInchRealtimeChartMediator(contentInchRealtime.panelChart));
		}
		
		private function onMediatorRemove(event:FlexEvent):void
		{
			facade.removeMediator(PanelInchRealtimeTempMediator.NAME);
			facade.removeMediator(PanelInchRealtimeValueMediator.NAME);
			facade.removeMediator(PanelInchRealtimeAlarmMediator.NAME);
			facade.removeMediator(PanelInchRealtimeChartMediator.NAME);
		}
	}
}