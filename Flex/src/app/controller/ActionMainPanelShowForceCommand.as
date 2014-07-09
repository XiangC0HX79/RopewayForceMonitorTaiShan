package app.controller
{
	import app.view.MainPanelForceSWFMediator;
	
	public class ActionMainPanelShowForceCommand extends BaseActionMainPanelChangeCommand
	{
		final override protected function get mediatorName():String
		{
			return MainPanelForceSWFMediator.NAME;
		}
	}
}