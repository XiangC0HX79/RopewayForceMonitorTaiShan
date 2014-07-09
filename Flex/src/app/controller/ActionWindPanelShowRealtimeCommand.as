package app.controller
{
	import app.view.ContentWindRealtimeMediator;
	
	public class ActionWindPanelShowRealtimeCommand extends BaseActionWindPanelChangeCommand
	{		
		final override protected function get mediatorName():String
		{
			return ContentWindRealtimeMediator.NAME;
		}
	}
}