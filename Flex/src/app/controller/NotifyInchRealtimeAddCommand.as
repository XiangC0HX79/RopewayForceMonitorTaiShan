package app.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NotifyInchRealtimeAddCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ActionUpdateInchCommand);
			
			addSubCommand(ActionUpdateInchHistoryCommand)
		}
	}
}