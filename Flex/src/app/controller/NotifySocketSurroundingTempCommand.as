package app.controller
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.InchProxy;
	import app.model.SurroundingTempProxy;
	import app.model.dict.RopewayDict;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.InchVO;
	import app.model.vo.SurroundingTempVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NotifySocketSurroundingTempCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ProxySurroundingTempUpdateCommand);
			
			addSubCommand(ActionUpdateSurroundingTempFstCommand);
			
			addSubCommand(ActionUpdateSurroundingTempSndCommand);
		}
	}
}