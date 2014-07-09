package app.view
{
	import mx.events.FlexEvent;
	
	import app.view.components.ContentWindAnalysis;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ContentWindAnalysisMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentWindAnalysisMediator";
		
		public function ContentWindAnalysisMediator()
		{
			super(NAME, new ContentWindAnalysis);
		}
		
		protected function get contentWindAnalysis():ContentWindAnalysis
		{
			return viewComponent as ContentWindAnalysis;
		}
		
		override public function onRegister():void
		{
			contentWindAnalysis.addEventListener(FlexEvent.ADD,onMediatorAdd);
			contentWindAnalysis.addEventListener(FlexEvent.REMOVE,onMediatorRemove);
		}
		
		private function onMediatorAdd(event:FlexEvent):void
		{			
			facade.registerMediator(new PanelWindAnalysisValueMediator(contentWindAnalysis.analysisValue));
			facade.registerMediator(new PanelWindAnalysisValueAveMediator(contentWindAnalysis.analysisValueAve));
			facade.registerMediator(new PanelWindAnalysisAlarmMediator(contentWindAnalysis.analysisAlarm));
		}
		
		private function onMediatorRemove(event:FlexEvent):void
		{			
			facade.removeMediator(PanelWindAnalysisValueMediator.NAME);
			facade.removeMediator(PanelWindAnalysisValueAveMediator.NAME);
			facade.removeMediator(PanelWindAnalysisAlarmMediator.NAME);
		}
	}
}