package app.controller
{
	import mx.collections.ArrayCollection;
	import mx.collections.ISort;
	
	import app.ApplicationFacade;
	import app.model.AppParamProxy;
	import app.model.WindProxy;
	import app.model.vo.WindVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class ActionRefreshWindCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			var appParamPx:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
			
			var windPx:WindProxy = facade.retrieveProxy(WindProxy.NAME) as WindProxy;
			
			var col:Array = [];
			for each(var wind:WindVO in windPx.list)
			{
				if(wind.bracket.ropeway.fullName == appParamPx.appParam.selRopeway.fullName)
				{
					col.push(wind);
				}
			}
			col.sort(compareFunction);
			
			sendNotification(ApplicationFacade.ACTION_REFRESH_WIND,col);
		}
		
		private function compareFunction(a:WindVO,b:WindVO):int
		{
			if(a.bracket.bracketId < b.bracket.bracketId)
				return -1;
			else if(a.bracket.bracketId == b.bracket.bracketId)
				return 0;
			else
				return 1;			
		}
	}
}