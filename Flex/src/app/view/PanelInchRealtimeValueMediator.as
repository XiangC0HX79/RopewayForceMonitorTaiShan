package app.view
{
	import app.ApplicationFacade;
	import app.model.InchProxy;
	import app.model.dict.RopewayDict;
	import app.model.vo.InchHistoryVO;
	import app.model.vo.InchVO;
	import app.view.components.PanelInchRealtimeValue;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelInchRealtimeValueMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelInchValueMediator";
		
		public function PanelInchRealtimeValueMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelInchValue():PanelInchRealtimeValue
		{
			return viewComponent as PanelInchRealtimeValue;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_INCH,
				
				ApplicationFacade.ACTION_UPDATE_INCH_HISTORY
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_INCH:
					panelInchValue.inch = notification.getBody() as InchVO;
					break;
				
				case ApplicationFacade.ACTION_UPDATE_INCH_HISTORY:
					panelInchValue.inchHistory = notification.getBody() as InchHistoryVO;
					break;
			}
		}		
	}
}