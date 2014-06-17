package app.controller
{
	import app.ApplicationFacade;
	import app.model.InchHistoryProxy;
	import app.view.ContentInchRealtimeMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NotifyMenuInchManagerCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ActionInchPanelChangeCommand);
		}
	}
}