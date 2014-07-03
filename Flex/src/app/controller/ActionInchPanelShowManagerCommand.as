package app.controller
{
	import app.view.ContentInchManageMediator;
	
	public class ActionInchPanelShowManagerCommand extends BaseActionInchPanelChangeCommand
	{		
		final override protected function get mediatorName():String
		{
			return ContentInchManageMediator.NAME;
		}
	}
}