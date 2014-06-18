package app.controller
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.InchProxy;
	import app.model.dict.RopewayDict;
	import app.model.vo.InchVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ActionUpdateInchValueCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;	
			
			switch(note.getName())
			{							
				case ApplicationFacade.NOTIFY_SOCKET_INCH:
					var rw:RopewayDict = note.getBody()[0];
					if(rw == configProxy.config.ropeway)
						updateInch(configProxy.config.ropeway);
					break;
				
				default:
					updateInch(configProxy.config.ropeway);
					break;
			}
		}
		
		private function updateInch(rw:RopewayDict):void
		{			
			var inchProxy:InchProxy = facade.retrieveProxy(InchProxy.NAME) as InchProxy;		
			
			var inch:InchVO = inchProxy.dict[rw];
			
			sendNotification(ApplicationFacade.ACTION_UPDATE_INCH,inch.lastValue);
		}
	}
}