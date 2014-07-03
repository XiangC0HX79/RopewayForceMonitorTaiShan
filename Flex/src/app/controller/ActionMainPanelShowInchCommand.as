package app.controller
{
	import app.view.MainPanelInchMediator;
	
	public class ActionMainPanelShowInchCommand extends BaseActionMainPanelChangeCommand
	{
		final override protected function get mediatorName():String
		{
			return MainPanelInchMediator.NAME;
		}
	}
}