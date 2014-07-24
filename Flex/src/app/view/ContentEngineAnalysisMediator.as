package app.view
{
	import mx.events.FlexEvent;
	
	import app.view.components.ContentEngineAnalysis;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ContentEngineAnalysisMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentEngineAnalysisMediator";
		
		public function ContentEngineAnalysisMediator(viewComponent:Object=null)
		{
			super(NAME, new ContentEngineAnalysis);
		}
		
		protected function get contentEngineAnalysis():ContentEngineAnalysis
		{
			return viewComponent as ContentEngineAnalysis;
		}
		
		override public function onRegister():void
		{
			contentEngineAnalysis.addEventListener(FlexEvent.ADD,onMediatorAdd);
			contentEngineAnalysis.addEventListener(FlexEvent.REMOVE,onMediatorRemove);
		}
		
		private function onMediatorAdd(event:FlexEvent):void
		{			
			facade.registerMediator(new PanelEngineAnalysisValueMediator(contentEngineAnalysis.analysisValue));
			facade.registerMediator(new PanelEngineAnalysisAverageMediator(contentEngineAnalysis.analysisAverage));
		}
		
		private function onMediatorRemove(event:FlexEvent):void
		{			
			facade.removeMediator(PanelEngineAnalysisValueMediator.NAME);
			facade.removeMediator(PanelEngineAnalysisAverageMediator.NAME);
		}
	}
}