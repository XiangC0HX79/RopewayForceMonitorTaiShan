package app.controller
{
	import app.view.ContentEngineAnalysisMediator;
	
	public class ActionEnginePanelShowAnalysisCommand extends BaseActionEnginePanelChangeCommand
	{		
		final override protected function get mediatorName():String
		{
			return ContentEngineAnalysisMediator.NAME;
		}
	}
}