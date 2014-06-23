package app.controller
{	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	
	import spark.components.Application;
	
	public class StartupCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ModelPreCommand);
			
			addSubCommand(ViewPreCommand);
			
			addSubCommand(NotifyInitAppCommand);
		}
	}
}