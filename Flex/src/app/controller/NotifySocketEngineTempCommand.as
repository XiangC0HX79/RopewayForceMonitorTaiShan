package app.controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class NotifySocketEngineTempCommand extends MacroCommand implements ICommand
	{		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ProxyEngineTempAddItemCommand);
			addSubCommand(ActionUpdateEngineTempFstCommand);
			addSubCommand(ActionUpdateEngineTempSndCommand);
		}
		
	}
}