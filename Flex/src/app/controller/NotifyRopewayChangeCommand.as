package app.controller
{
	import app.ApplicationFacade;
	import app.model.AppConfigProxy;
	import app.model.InchProxy;
	import app.model.InchProxy;
	import app.model.SurroundingTempProxy;
	import app.model.vo.RopewayVO;
	import app.model.vo.RopewayStationVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifyRopewayChangeCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{			
			addSubCommand(ProxyAppParmaUpdateRopewayCommand);
			
			addSubCommand(ActionUpdateInchCommand);
			
			addSubCommand(ActionUpdateSurroundingCommand);
			
			addSubCommand(ActionUpdateEngineCommand);
			
			addSubCommand(ActionUpdateForceCommand);
		}
	}
}