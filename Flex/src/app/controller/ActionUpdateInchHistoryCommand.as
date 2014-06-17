package app.controller
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.InchHistoryProxy;
	import app.model.InchProxy;
	import app.model.dict.RopewayDict;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ActionUpdateInchHistoryCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;		
			
			switch(note.getName())
			{
				case ApplicationFacade.NOTIFY_INCH_REALTIME_ADD:
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_CHANGE:
					break;
				
				case ApplicationFacade.NOTIFY_SOCKET_INCH:
					var rw:RopewayDict = note.getBody()[0];
					if(rw != configProxy.config.ropeway)return;
					break;
			}
			
			var inchHistoryProxy:InchHistoryProxy =  facade.retrieveProxy(InchHistoryProxy.NAME) as InchHistoryProxy;				
			sendNotification(ApplicationFacade.ACTION_UPDATE_INCH_HISTORY,inchHistoryProxy.dict[configProxy.config.ropeway]);
		}
	}
}