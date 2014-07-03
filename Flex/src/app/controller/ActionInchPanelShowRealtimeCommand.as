package app.controller
{
	import app.view.ContentInchRealtimeMediator;
	
	public class ActionInchPanelShowRealtimeCommand extends BaseActionInchPanelChangeCommand
	{		
		final override protected function get mediatorName():String
		{
			return ContentInchRealtimeMediator.NAME;
		}
	}
}