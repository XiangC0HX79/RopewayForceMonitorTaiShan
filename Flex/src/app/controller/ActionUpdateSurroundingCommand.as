package app.controller
{
	import app.ApplicationFacade;
	import app.model.AppConfigProxy;
	import app.model.AppParamProxy;
	import app.model.SurroundingTempProxy;
	import app.model.vo.RopewayStationVO;
	import app.model.vo.RopewayVO;
	import app.model.vo.SurroundingTempVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ActionUpdateSurroundingCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{			
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;	
			
			var surroundingTempProxy:SurroundingTempProxy = facade.retrieveProxy(SurroundingTempProxy.NAME) as SurroundingTempProxy;		
			
			switch(notification.getName())
			{				
				case ApplicationFacade.NOTIFY_SOCKET_SURROUDING_TEMP:
					var st:SurroundingTempVO = SurroundingTempVO(notification.getBody());
					
					if(st.ropewayStation.ropeway.fullName == appParamProxy.appParam.selRopeway.fullName)
					{
						if(st.ropewayStation.station == RopewayStationVO.FIRST)
						{
							sendNotification(ApplicationFacade.ACTION_UPDATE_SURROUDING_TEMP_FST,st);
						}
						else if(st.ropewayStation.station == RopewayStationVO.SECOND)
						{
							sendNotification(ApplicationFacade.ACTION_UPDATE_SURROUDING_TEMP_SND,st);
						}
					}
					break;
				
				default:
					for each(st in surroundingTempProxy.list)
					{
						if(st.ropewayStation.ropeway.fullName != appParamProxy.appParam.selRopeway.fullName)
							continue;
						
						if(st.ropewayStation.station == RopewayStationVO.FIRST)
						{
							sendNotification(ApplicationFacade.ACTION_UPDATE_SURROUDING_TEMP_FST,st);
						}
						else if(st.ropewayStation.station == RopewayStationVO.SECOND)
						{
							sendNotification(ApplicationFacade.ACTION_UPDATE_SURROUDING_TEMP_SND,st);
						}					
					}
					break;
			}
		}		
	}
}