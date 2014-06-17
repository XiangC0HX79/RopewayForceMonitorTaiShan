package app.controller
{
	import app.ApplicationFacade;
	import app.model.InchProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ProxyInchInitCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			switch(note.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					break;
			}
			
			var inchProxy:InchProxy = facade.retrieveProxy(InchProxy.NAME) as InchProxy;
			inchProxy.Init();
		}
	}
}