package app.controller
{
	import app.ApplicationFacade;
	import app.view.MainPanelInchMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncMacroCommand;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NotifyMenuMainInchCommand extends AsyncMacroCommand
	{
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionMainPanelChangeCommand);
			
			addSubCommand(ActionInchPanelChangeCommand);
			
			addSubCommand(ProxyInchInitCommand);
			
			addSubCommand(ActionUpdateInchValueCommand);
			
			addSubCommand(ActionUpdateInchCommand)
		}
	}
}