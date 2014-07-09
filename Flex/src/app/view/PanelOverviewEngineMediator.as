package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelOverviewEngine;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelOverviewEngineMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelOverviewEngineMediator";
		
		public function PanelOverviewEngineMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelOverviewEngineTemp():PanelOverviewEngine
		{
			return viewComponent as PanelOverviewEngine;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_ROPEWAY
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_ROPEWAY:
					panelOverviewEngineTemp.engineFst = RopewayVO(notification.getBody()).engineFst;
					panelOverviewEngineTemp.engineSnd = RopewayVO(notification.getBody()).engineSnd;
					break;
			}
		}		
	}
}