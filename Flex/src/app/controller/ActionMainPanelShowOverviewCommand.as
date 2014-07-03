package app.controller
{
	import app.view.MainPanelOverviewMediator;
	
	public class ActionMainPanelShowOverviewCommand extends BaseActionMainPanelChangeCommand
	{
		final override protected function get mediatorName():String
		{
			return MainPanelOverviewMediator.NAME;
		}
	}
}