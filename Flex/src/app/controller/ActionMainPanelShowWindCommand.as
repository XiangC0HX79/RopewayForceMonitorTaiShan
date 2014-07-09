package app.controller
{
	import app.view.MainPanelWindMediator;
	
	public class ActionMainPanelShowWindCommand extends BaseActionMainPanelChangeCommand
	{
		final override protected function get mediatorName():String
		{
			return MainPanelWindMediator.NAME;
		}
	}
}