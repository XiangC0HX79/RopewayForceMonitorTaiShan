package app.view
{
	import flash.events.Event;
	
	import mx.events.ResizeEvent;
	
	import app.ApplicationFacade;
	import app.model.vo.RopewayVO;
	import app.model.vo.WindVO;
	import custom.components.ItemOverviewWind;
	import app.view.components.PanelOverviewWind;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelOverviewWindMediator extends Mediator
	{
		public static const NAME:String = "PanelOverviewWindMediator";
		
		public function PanelOverviewWindMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelOverviewWind():PanelOverviewWind
		{
			return viewComponent as PanelOverviewWind;
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
					panelOverviewWind.ropeway = RopewayVO(notification.getBody());
					break;
			}
		}
	}
}