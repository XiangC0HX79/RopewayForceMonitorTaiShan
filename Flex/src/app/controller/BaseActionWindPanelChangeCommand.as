package app.controller
{	
	import app.ApplicationFacade;
	
	public class BaseActionWindPanelChangeCommand extends BaseActionPanelChangeCommand
	{		
		final override protected function get action():String
		{
			return ApplicationFacade.ACTION_WIND_PANEL_CHANGE;
		}		
	}
}