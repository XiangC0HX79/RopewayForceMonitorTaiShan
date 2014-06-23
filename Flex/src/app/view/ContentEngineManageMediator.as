package app.view
{
	import app.view.components.ContentEngineManager;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ContentEngineManageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentEngineManageMediator";
		
		public function ContentEngineManageMediator()
		{
			super(NAME, new ContentEngineManager);
		}
		
		protected function get contentEngineManager():ContentEngineManager
		{
			return viewComponent as ContentEngineManager;
		}
	}
}