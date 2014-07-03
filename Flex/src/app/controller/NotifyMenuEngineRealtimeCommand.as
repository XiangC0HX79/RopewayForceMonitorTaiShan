package app.controller
{
	import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
	
	public class NotifyMenuEngineRealtimeCommand extends AsyncMacroCommand
	{		
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionEnginePanelShowRealtimeCommand);
			
			addSubCommand(ActionUpdateRopewayCommand);
		}
		
	}
}