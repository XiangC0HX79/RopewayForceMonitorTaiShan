package app.view
{
	import app.view.components.MainPanelOverview;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainPanelOverviewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainPanelOverviewMediator";
		
		public function MainPanelOverviewMediator()
		{
			super(NAME, new MainPanelOverview);
		}
		
		protected function get m():MainPanelOverview
		{
			return viewComponent as MainPanelOverview;
		}
	}
}