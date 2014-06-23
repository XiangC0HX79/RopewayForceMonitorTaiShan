package app.controller
{
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	
	public class NotifySocketEngineTempCommand extends MacroCommand implements ICommand
	{		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ProxyEngineAddItemCommand);
			
			addSubCommand(ActionUpdateEngineCommand);
		}
		
	}
}