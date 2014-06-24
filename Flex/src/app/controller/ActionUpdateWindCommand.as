package app.controller
{
	import app.ApplicationFacade;
	import app.model.AppParamProxy;
	import app.model.WindProxy;
	import app.model.vo.BracketVO;
	import app.model.vo.InchVO;
	import app.model.vo.RopewayVO;
	import app.model.vo.WindVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ActionUpdateWindCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;	
			
			var windProxy:WindProxy =  facade.retrieveProxy(WindProxy.NAME) as WindProxy;		
			
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_SOCKET_WIND:
					var bra:BracketVO = BracketVO(notification.getBody()[0]);
					if(bra.ropeway.fullName == appParamProxy.appParam.selRopeway.fullName)
					{
						var wind:WindVO = windProxy.retrieveWind(bra);
						
						sendNotification(ApplicationFacade.ACTION_UPDATE_WIND,wind);			
					}
					break;
			}
		}
		
	}
}