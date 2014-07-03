package app.controller
{
	import app.view.ContentEngineRealtimeMediator;
	
	public class ActionEnginePanelShowRealtimeCommand extends BaseActionEnginePanelChangeCommand
	{		
		final override protected function get mediatorName():String
		{
			return ContentEngineRealtimeMediator.NAME;
		}
	}
}