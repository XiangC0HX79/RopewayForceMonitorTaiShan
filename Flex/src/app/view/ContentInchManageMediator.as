package app.view
{
	import app.view.components.ContentInchManage;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ContentInchManageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentInchManageMediator";
		
		public function ContentInchManageMediator()
		{
			super(NAME, new ContentInchManage);
		}
		
		protected function get contentInchManage():ContentInchManage
		{
			return viewComponent as ContentInchManage;
		}
	}
}