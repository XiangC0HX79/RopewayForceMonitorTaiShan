package app.view
{
	import app.view.components.ContentInchAnalysis;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
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
	}
}