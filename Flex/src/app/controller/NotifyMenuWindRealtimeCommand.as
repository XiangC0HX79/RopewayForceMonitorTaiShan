package app.controller
{
	import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
	
	public class NotifyMenuWindRealtimeCommand extends AsyncMacroCommand
	{
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionWindPanelShowRealtimeCommand);
						
			addSubCommand(ActionUpdateRopewayCommand)
		}		
	}
}