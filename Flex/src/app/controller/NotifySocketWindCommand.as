package app.controller
{
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	
	public class NotifySocketWindCommand extends MacroCommand
	{		
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ProxyWindAddItemCommand);
			
			addSubCommand(ActionUpdateWindCommand);
		}
		
	}
}