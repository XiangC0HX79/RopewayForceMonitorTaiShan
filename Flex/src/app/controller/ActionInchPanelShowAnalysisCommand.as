package app.controller
{
	import app.view.ContentInchAnalysisMediator;
	
	public class ActionInchPanelShowAnalysisCommand extends BaseActionInchPanelChangeCommand
	{		
		final override protected function get mediatorName():String
		{
			return ContentInchAnalysisMediator.NAME;
		}
	}
}