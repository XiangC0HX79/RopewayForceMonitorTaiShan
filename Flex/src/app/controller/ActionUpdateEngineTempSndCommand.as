package app.controller
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.EngineTempProxy;
	import app.model.InchProxy;
	import app.model.SurroundingTempProxy;
	import app.model.dict.RopewayDict;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.EngineVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ActionUpdateEngineTempSndCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;	
			
			switch(notification.getName())
			{				
				case ApplicationFacade.NOTIFY_SOCKET_ENGINE_TEMP:
					var rw:RopewayDict = notification.getBody()[0];
					var pos:int = notification.getBody()[1];
					if((rw != configProxy.config.ropeway) || (pos != EngineVO.SECOND))return;
					break;
			}
			
			var engineTempProxy:EngineTempProxy = facade.retrieveProxy(EngineTempProxy.NAME) as EngineTempProxy;		
			
			for each(var engine:EngineVO in engineTempProxy.list)
			{
				if((engine.ropeway == configProxy.config.ropeway) && (engine.pos == EngineVO.SECOND))
				{
					sendNotification(ApplicationFacade.ACTION_UPDATE_ENGINE_TEMP_SND,engine.lastTemp);
				}
			}
		}
	}
}