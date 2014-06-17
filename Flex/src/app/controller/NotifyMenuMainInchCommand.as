package app.controller
{
	import app.ApplicationFacade;
	import app.view.MainPanelInchMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NotifyMenuMainInchCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ActionMainPanelChangeCommand);
			
			addSubCommand(ActionInchPanelChangeCommand);
			
			addSubCommand(ProxyInchHistoryInitCommand);
		}
	}
}