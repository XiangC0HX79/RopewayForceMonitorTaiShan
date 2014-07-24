package app.view
{
	import mx.events.FlexEvent;
	
	import app.view.components.ContentInchAnalysis;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ContentInchAnalysisMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentInchAnalysisMediator";
		
		public function ContentInchAnalysisMediator()
		{
			super(NAME, new ContentInchAnalysis);
		}
		
		protected function get contentInchAnalysis():ContentInchAnalysis
		{
			return viewComponent as ContentInchAnalysis;
		}
		
		override public function onRegister():void
		{
			contentInchAnalysis.addEventListener(FlexEvent.ADD,onMediatorAdd);
			contentInchAnalysis.addEventListener(FlexEvent.REMOVE,onMediatorRemove);
		}
		
		private function onMediatorAdd(event:FlexEvent):void
		{			
			facade.registerMediator(new PanelInchAnalysisValueMediator(contentInchAnalysis.analysisValue));
			facade.registerMediator(new PanelInchAnalysisAverageMediator(contentInchAnalysis.analysisAverage));
		}
		
		private function onMediatorRemove(event:FlexEvent):void
		{			
			facade.removeMediator(PanelInchAnalysisValueMediator.NAME);
			facade.removeMediator(PanelInchAnalysisAverageMediator.NAME);
		}
	}
}