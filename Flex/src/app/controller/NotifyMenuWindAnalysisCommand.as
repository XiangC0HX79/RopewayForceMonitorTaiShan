package app.controller
{
	import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
	
	public class NotifyMenuWindAnalysisCommand extends AsyncMacroCommand
	{
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionWindPanelShowAnalysisCommand);
			
			addSubCommand(ActionUpdateRopewayCommand)
		}		
	}
}