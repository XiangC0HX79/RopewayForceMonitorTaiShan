package app.controller
{
	import app.view.ContentWindAnalysisMediator;
	
	public class ActionWindPanelShowAnalysisCommand extends BaseActionWindPanelChangeCommand
	{		
		final override protected function get mediatorName():String
		{
			return ContentWindAnalysisMediator.NAME;
		}
	}
}