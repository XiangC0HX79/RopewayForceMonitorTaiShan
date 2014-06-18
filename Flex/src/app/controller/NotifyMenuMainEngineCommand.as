package app.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.AsyncMacroCommand;
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class NotifyMenuMainEngineCommand extends AsyncMacroCommand
	{		
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionMainPanelChangeCommand);
			
			addSubCommand(ActionEnginePanelChangeCommand);
		}
		
	}
}