package app.controller
{
	import mx.core.IVisualElement;
	
	import app.ApplicationFacade;
	import app.model.AppConfigProxy;
	import app.model.InchProxy;
	import app.model.vo.RopewayVO;
	import app.view.ApplicationMediator;
	import app.view.MainPanelOverviewMediator;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.AsyncMacroCommand;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifyInitAppCompleteCommand extends AsyncMacroCommand
	{  
		override protected function initializeAsyncMacroCommand():void
		{
			addSubCommand(ActionMainPanelShowOverviewCommand);
			
			addSubCommand(ActionUpdateSurroundingCommand);
						
			//addSubCommand(ActionUpdateSurroundingCommand);
			
			//addSubCommand(ActionUpdateInchCommand);
			
			//addSubCommand(ActionRefreshWindCommand);
		}
	}
}