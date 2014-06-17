package app.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class NotifyMainOverviewAddCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ActionUpdateSurroundingTempFstCommand);
			
			addSubCommand(ActionUpdateSurroundingTempSndCommand);
			
			addSubCommand(ActionUpdateInchCommand);
		}
	}
}