package app.controller
{
	import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
	
	public class NotifyMenuEngineManagerCommand extends AsyncMacroCommand
	{		
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionEnginePanelChangeCommand);
		}
		
	}
}