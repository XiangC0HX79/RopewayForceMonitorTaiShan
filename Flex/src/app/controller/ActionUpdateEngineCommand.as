package app.controller
{
	import app.ApplicationFacade;
	import app.model.AppParamProxy;
	import app.model.EngineProxy;
	import app.model.vo.EngineVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ActionUpdateEngineCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
			
			var engineTempProxy:EngineProxy = facade.retrieveProxy(EngineProxy.NAME) as EngineProxy;	
			
			switch(notification.getName())
			{				
				case ApplicationFacade.NOTIFY_SOCKET_ENGINE_TEMP:
					var rw:RopewayVO = RopewayVO(notification.getBody()[0]);
					var pos:int = int(notification.getBody()[1]);
					
					if(appParamProxy.appParam.selRopeway.fullName == rw.fullName)
					{
						var engine:EngineVO = engineTempProxy.retreiveEngine(rw,pos);
						if(engine.pos == EngineVO.FIRST)
						{							
							sendNotification(ApplicationFacade.ACTION_UPDATE_ENGINE_FST,engine);
						}
						else if(engine.pos == EngineVO.SECOND)
						{
							sendNotification(ApplicationFacade.ACTION_UPDATE_ENGINE_SND,engine);
						}
					}
					break;
				
				default:
					for each (engine in engineTempProxy.list)
					{				
						if(engine.ropeway.fullName != appParamProxy.appParam.selRopeway.fullName)
							continue;
						
						if(engine.pos == EngineVO.FIRST)
						{							
							sendNotification(ApplicationFacade.ACTION_UPDATE_ENGINE_FST,engine);
						}
						else if(engine.pos == EngineVO.SECOND)
						{
							sendNotification(ApplicationFacade.ACTION_UPDATE_ENGINE_SND,engine);
						}
					}
					break;
			}
		}
	}
}