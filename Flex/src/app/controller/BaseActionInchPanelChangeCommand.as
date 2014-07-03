package app.controller
{	
	import app.ApplicationFacade;
	
	public class BaseActionInchPanelChangeCommand extends BaseActionPanelChangeCommand
	{		
		final override protected function get action():String
		{
			return ApplicationFacade.ACTION_INCH_PANEL_CHANGE;
		}		
	}
}