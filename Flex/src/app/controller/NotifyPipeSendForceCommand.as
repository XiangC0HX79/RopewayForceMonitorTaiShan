package app.controller
{
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifyPipeSendForceCommand extends MacroCommand
	{				
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ProxyForceUpdateCommand);
			addSubCommand(ActionUpdateForceCommand);
		}
		
	}
}