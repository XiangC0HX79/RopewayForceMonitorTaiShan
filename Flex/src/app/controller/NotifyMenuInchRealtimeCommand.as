package app.controller
{
	import app.ApplicationFacade;
	import app.model.InchProxy;
	import app.view.ContentInchRealtimeMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncMacroCommand;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NotifyMenuInchRealtimeCommand extends AsyncMacroCommand
	{
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionInchPanelChangeCommand);
			
			addSubCommand(ActionUpdateInchValueCommand);
			
			addSubCommand(ActionUpdateInchCommand)
		}		
	}
}