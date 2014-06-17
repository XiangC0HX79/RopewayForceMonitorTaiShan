package app.controller
{
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.InchHistoryProxy;
	import app.model.InchProxy;
	import app.model.dict.RopewayDict;
	import app.model.vo.InchHistoryVO;
	import app.model.vo.InchVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.patterns.observer.Notification;
	
	public class NotifySocketInchCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ProxyInchUpdateCommand);
			addSubCommand(ProxyInchHistoryAddItemCommand);
			
			addSubCommand(ActionUpdateInchCommand);
			addSubCommand(ActionUpdateInchHistoryCommand);
		}
	}
}