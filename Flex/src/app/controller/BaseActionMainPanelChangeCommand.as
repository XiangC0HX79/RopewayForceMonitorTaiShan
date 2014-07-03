package app.controller
{	
	import app.ApplicationFacade;
	
	public class BaseActionMainPanelChangeCommand extends BaseActionPanelChangeCommand
	{		
		final override protected function get action():String
		{
			return ApplicationFacade.ACTION_MAIN_PANEL_CHANGE;
		}		
	}
}