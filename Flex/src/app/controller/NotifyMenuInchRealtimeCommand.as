package app.controller
{
	import app.ApplicationFacade;
	import app.model.InchProxy;
	import app.view.ContentInchRealtimeMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifyMenuInchRealtimeCommand extends AsyncMacroCommand
	{
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionInchPanelChangeCommand);
						
			addSubCommand(ActionUpdateInchCommand)
		}		
	}
}