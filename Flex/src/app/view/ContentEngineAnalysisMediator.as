package app.view
{
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
	}
}