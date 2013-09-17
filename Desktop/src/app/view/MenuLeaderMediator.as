package app.view
{
	import app.view.components.MenuLeader;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MenuLeaderMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MenuLeaderMediator";
		
		public function MenuLeaderMediator(viewComponent:Object=null)
		{
			super(NAME,viewComponent);
		}
		
		protected function get menuLeader():MenuLeader
		{
			return viewComponent as MenuLeader;
		}
	}
}