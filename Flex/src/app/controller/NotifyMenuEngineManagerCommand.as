package app.controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class NotifyMenuEngineManagerCommand extends MacroCommand
	{		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ActionEnginePanelChangeCommand);
		}
		
	}
}