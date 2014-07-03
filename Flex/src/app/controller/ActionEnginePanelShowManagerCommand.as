package app.controller
{
	import app.view.ContentEngineManageMediator;
	
	public class ActionEnginePanelShowManagerCommand extends BaseActionEnginePanelChangeCommand
	{		
		final override protected function get mediatorName():String
		{
			return ContentEngineManageMediator.NAME;
		}
	}
}