package app.view
{
	import app.view.components.ContentWindManager;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ContentWindManagerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentWindManagerMediator";
		
		public function ContentWindManagerMediator()
		{
			super(NAME, new ContentWindManager);
		}
		
		protected function get contentWindManager():ContentWindManager
		{
			return viewComponent as ContentWindManager;
		}
	}
}