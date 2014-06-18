package app.controller
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.SurroundingTempProxy;
	import app.model.dict.RopewayDict;
	import app.model.dict.RopewayStationDict;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ActionUpdateSurroundingTempSndCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{			
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;		
			
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_SOCKET_SURROUDING_TEMP:
					var rs:RopewayStationDict = notification.getBody()[0];
					if((rs.ropeway == configProxy.config.ropeway) && (rs.station == RopewayStationDict.SECOND))
					{
						updateSurroudingTemp(configProxy.config.ropeway);
					}
					break;
				
				default:
					updateSurroudingTemp(configProxy.config.ropeway);
					break;
			}
		}
		
		private function updateSurroudingTemp(rw:RopewayDict):void
		{			
			var surroundingTempProxy:SurroundingTempProxy = facade.retrieveProxy(SurroundingTempProxy.NAME) as SurroundingTempProxy;		
			
			for(var key:* in surroundingTempProxy.dict)
			{
				if((key.ropeway == rw) && (key.station == RopewayStationDict.SECOND))
				{
					sendNotification(ApplicationFacade.ACTION_UPDATE_SURROUDING_TEMP_SND,surroundingTempProxy.dict[key]);
				}
			}			
		}
	}
}