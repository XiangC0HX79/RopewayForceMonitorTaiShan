package app.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NotifyMenuMainForceCommand extends MacroCommand implements ICommand
	{				
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ActionMainPanelChangeCommand);
		}
		
	}
}