package app.controller
{
	import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
	
	public class NotifyMenuMainOverviewCommand extends AsyncMacroCommand
	{
		override protected function initializeAsyncMacroCommand():void
		{			
			addSubCommand(ActionMainPanelShowOverviewCommand);
						
			addSubCommand(ActionUpdateRopewayCommand);
		}
	}
}