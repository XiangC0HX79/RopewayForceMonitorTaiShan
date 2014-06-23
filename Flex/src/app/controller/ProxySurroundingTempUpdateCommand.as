package app.controller
{
	import app.ApplicationFacade;
	import app.model.SurroundingTempProxy;
	import app.model.vo.RopewayStationVO;
	import app.model.vo.SurroundingTempVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ProxySurroundingTempUpdateCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void
		{			
			switch(notification.getName())
			{				
				case ApplicationFacade.NOTIFY_SOCKET_SURROUDING_TEMP:		
					var surroundingTempProxy:SurroundingTempProxy = facade.retrieveProxy(SurroundingTempProxy.NAME) as SurroundingTempProxy;	
					surroundingTempProxy.Update(SurroundingTempVO(notification.getBody()));
					break;
			}
		}
	}
}