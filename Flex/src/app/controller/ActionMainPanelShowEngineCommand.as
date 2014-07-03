package app.controller
{
	import app.view.MainPanelEngineMediator;
	
	public class ActionMainPanelShowEngineCommand extends BaseActionMainPanelChangeCommand
	{		
		final override protected function get mediatorName():String
		{
			return MainPanelEngineMediator.NAME;
		}		
	}
}