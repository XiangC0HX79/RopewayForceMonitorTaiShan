package app.controller
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.SurroundingTempProxy;
	import app.model.dict.RopewayStationDict;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ActionUpdateSurroundingTempFstCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{			
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;	
			
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MAIN_OVERVIEW_ADD:	
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_CHANGE:
					break;
				
				case ApplicationFacade.NOTIFY_SOCKET_SURROUDING_TEMP:
					var rs:RopewayStationDict = notification.getBody()[0];
					if((rs.ropeway != configProxy.config.ropeway) || (rs.station != RopewayStationDict.FIRST))return;
					break;
			}
			
			var surroundingTempProxy:SurroundingTempProxy = facade.retrieveProxy(SurroundingTempProxy.NAME) as SurroundingTempProxy;		
			
			for(var key:* in surroundingTempProxy.dict)
			{
				if((key.ropeway == configProxy.config.ropeway) && (key.station == RopewayStationDict.FIRST))
				{
					sendNotification(ApplicationFacade.ACTION_UPDATE_SURROUDING_TEMP_FST,surroundingTempProxy.dict[key]);
				}
			}
		}
		
	}
}