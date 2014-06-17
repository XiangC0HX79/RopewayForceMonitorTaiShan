package app.controller
{
	import mx.core.IVisualElement;
	
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.InchProxy;
	import app.model.dict.RopewayDict;
	import app.view.ApplicationMediator;
	import app.view.MainPanelOverviewMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NotifyInitAppCompleteCommand extends MacroCommand implements ICommand
	{  
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ProxyInchInitCommand);
			
			addSubCommand(ActionMainPanelChangeCommand);
		}
	}
}