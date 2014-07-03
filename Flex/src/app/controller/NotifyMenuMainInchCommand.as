package app.controller
{	
	import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
	
	public class NotifyMenuMainInchCommand extends AsyncMacroCommand
	{
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionMainPanelShowInchCommand);
			
			addSubCommand(ActionInchPanelShowRealtimeCommand);
						
			addSubCommand(ActionUpdateRopewayCommand)
		}
	}
}