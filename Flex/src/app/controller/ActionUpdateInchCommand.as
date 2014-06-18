package app.controller
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.InchProxy;
	import app.model.dict.RopewayDict;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ActionUpdateInchCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;		
			
			switch(note.getName())
			{
				case ApplicationFacade.NOTIFY_SOCKET_INCH:
					var rw:RopewayDict = note.getBody()[0];
					if(rw == configProxy.config.ropeway)
						updateInchHistory(configProxy.config.ropeway)
					break;
				
				default:
					updateInchHistory(configProxy.config.ropeway)
					break;
			}
			
		}
		
		private function updateInchHistory(rw:RopewayDict):void
		{
			var inchProxy:InchProxy =  facade.retrieveProxy(app.model.InchProxy.NAME) as app.model.InchProxy;				
			sendNotification(ApplicationFacade.ACTION_UPDATE_INCH_HISTORY,inchProxy.dict[rw]);			
		}
	}
}