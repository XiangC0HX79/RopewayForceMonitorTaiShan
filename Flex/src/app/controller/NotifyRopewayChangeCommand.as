package app.controller
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.InchProxy;
	import app.model.InchProxy;
	import app.model.SurroundingTempProxy;
	import app.model.dict.RopewayDict;
	import app.model.dict.RopewayStationDict;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NotifyRopewayChangeCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ProxyConfigUpdateCommand);
			
			addSubCommand(ActionUpdateInchValueCommand);
			addSubCommand(ActionUpdateInchCommand);
			addSubCommand(ActionUpdateSurroundingTempFstCommand);
			addSubCommand(ActionUpdateSurroundingTempSndCommand);
		}
	}
}