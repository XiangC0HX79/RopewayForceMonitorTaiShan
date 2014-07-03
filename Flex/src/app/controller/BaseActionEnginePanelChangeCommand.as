package app.controller
{	
	import app.ApplicationFacade;
	
	public class BaseActionEnginePanelChangeCommand extends BaseActionPanelChangeCommand
	{		
		final override protected function get action():String
		{
			return ApplicationFacade.ACTION_ENGINE_PANEL_CHANGE;
		}		
	}
}