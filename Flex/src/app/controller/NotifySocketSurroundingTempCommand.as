package app.controller
{
	import app.ApplicationFacade;
	import app.model.AppConfigProxy;
	import app.model.InchProxy;
	import app.model.SurroundingTempProxy;
	import app.model.vo.RopewayVO;
	import app.model.vo.RopewayStationVO;
	import app.model.vo.InchValueVO;
	import app.model.vo.SurroundingTempVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifySocketSurroundingTempCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ProxySurroundingTempUpdateCommand);
			
			addSubCommand(ActionUpdateSurroundingCommand);
		}
	}
}