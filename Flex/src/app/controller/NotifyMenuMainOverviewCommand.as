package app.controller
{
	import app.ApplicationFacade;
	import app.view.MainPanelOverviewMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.AsyncMacroCommand;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NotifyMenuMainOverviewCommand extends AsyncMacroCommand
	{
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionMainPanelChangeCommand);
			
			addSubCommand(ActionUpdateSurroundingTempFstCommand);
			
			addSubCommand(ActionUpdateSurroundingTempSndCommand);
			
			addSubCommand(ActionUpdateInchValueCommand);
		}
	}
}