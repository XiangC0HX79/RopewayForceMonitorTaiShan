package app.controller
{
	import app.ApplicationFacade;
	import app.model.AppConfigProxy;
	import app.model.AppParamProxy;
	import app.model.InchProxy;
	import app.model.vo.InchVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.interfaces.ICommand;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ActionUpdateInchCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;	
			
			var inchProxy:InchProxy =  facade.retrieveProxy(app.model.InchProxy.NAME) as app.model.InchProxy;		
			
			switch(note.getName())
			{
				case ApplicationFacade.NOTIFY_SOCKET_INCH:
					var rw:RopewayVO = RopewayVO(note.getBody()[0]);
					if(rw.fullName == appParamProxy.appParam.selRopeway.fullName)
					{
						var inch:InchVO = inchProxy.retrieveInch(rw);
						sendNotification(ApplicationFacade.ACTION_UPDATE_INCH,inch);			
					}
					break;
				
				default:
					for each(inch in inchProxy.list)
					{
						if(inch.ropeway.fullName != appParamProxy.appParam.selRopeway.fullName)
							continue;
						
						sendNotification(ApplicationFacade.ACTION_UPDATE_INCH,inch);							
					}
					break;
			}
			
		}
	}
}