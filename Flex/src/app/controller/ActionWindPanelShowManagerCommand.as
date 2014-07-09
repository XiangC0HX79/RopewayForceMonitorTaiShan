package app.controller
{
	import app.view.ContentWindManagerMediator;
	
	public class ActionWindPanelShowManagerCommand extends BaseActionWindPanelChangeCommand
	{		
		final override protected function get mediatorName():String
		{
			return ContentWindManagerMediator.NAME;
		}
	}
}