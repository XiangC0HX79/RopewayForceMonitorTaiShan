package app.controller
{
	import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
	
	public class NotifyMenuMainWindCommand extends AsyncMacroCommand
	{		
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionMainPanelShowWindCommand);
			
			addSubCommand(ActionWindPanelShowRealtimeCommand);
			
			addSubCommand(ActionUpdateRopewayCommand)
		}		
	}
}