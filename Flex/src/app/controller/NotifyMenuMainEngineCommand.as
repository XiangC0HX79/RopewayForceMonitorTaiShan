package app.controller
{
	import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
	
	public class NotifyMenuMainEngineCommand extends AsyncMacroCommand
	{		
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionMainPanelChangeCommand);
			
			addSubCommand(ActionEnginePanelChangeCommand);
			
			addSubCommand(ActionUpdateEngineCommand);
		}
		
	}
}