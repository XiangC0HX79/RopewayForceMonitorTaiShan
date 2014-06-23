package app.controller
{
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.AppConfigProxy;
	import app.model.InchProxy;
	import app.model.InchProxy;
	import app.model.vo.RopewayVO;
	import app.model.vo.InchVO;
	import app.model.vo.InchValueVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.MacroCommand;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	import org.puremvc.as3.multicore.patterns.observer.Notification;
	
	public class NotifySocketInchCommand extends MacroCommand implements ICommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand(ProxyInchAddItemCommand);
						
			addSubCommand(ActionUpdateInchCommand);
		}
	}
}