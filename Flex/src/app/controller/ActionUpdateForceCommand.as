package app.controller
{
	import app.ApplicationFacade;
	import app.model.AppConfigProxy;
	import app.model.AppParamProxy;
	import app.model.ForceProxy;
	import app.model.vo.ForceVO;
	import app.model.vo.RopewayStationVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ActionUpdateForceCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
			
			var forceProxy:ForceProxy = facade.retrieveProxy(ForceProxy.NAME) as ForceProxy;
			
			switch(notification.getName())
			{				
				case ApplicationFacade.NOTIFY_PIPE_SEND_FORCE:
					var force:ForceVO = ForceVO(notification.getBody());
					if(force.ropewayStation.ropeway.fullName == appParamProxy.appParam.selRopeway.fullName)
					{
						if(force.ropewayStation.station == RopewayStationVO.FIRST)
							sendNotification(ApplicationFacade.ACTION_UPDATE_FORCE_FST,force);
						else if(force.ropewayStation.station == RopewayStationVO.SECOND)
								sendNotification(ApplicationFacade.ACTION_UPDATE_FORCE_SND,force);							
					}
					break;
				
				default:
					for each(force in forceProxy.list)
					{
						if(force.ropewayStation.ropeway.fullName != appParamProxy.appParam.selRopeway.fullName)
							continue;
						
						if(force.ropewayStation.station == RopewayStationVO.FIRST)
							sendNotification(ApplicationFacade.ACTION_UPDATE_FORCE_FST,force);
						else if(force.ropewayStation.station == RopewayStationVO.SECOND)
							sendNotification(ApplicationFacade.ACTION_UPDATE_FORCE_SND,force);								
					}
					break;
			}
		}
	}
}