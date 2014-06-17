package app.view
{
	import app.ApplicationFacade;
	import app.model.dict.RopewayDict;
	import app.model.vo.InchVO;
	import app.view.components.PanelOverviewInch;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelOverviewInchMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelOverviewInchMediator";
		
		public function PanelOverviewInchMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelOverviewInch():PanelOverviewInch
		{
			return viewComponent as PanelOverviewInch;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_INCH
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_INCH:
					panelOverviewInch.inch = notification.getBody() as InchVO;
					break;
			}
		}		
	}
}