package app.view
{
	import app.ApplicationFacade;
	import app.model.InchProxy;
	import app.model.dict.RopewayDict;
	import app.model.vo.InchValueVO;
	import app.view.components.PanelInchRealtimeTemp;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelInchRealtimeTempMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelInchTempMediator";
		
		public function PanelInchRealtimeTempMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelInchTemp():PanelInchRealtimeTemp
		{
			return viewComponent as PanelInchRealtimeTemp
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
					panelInchTemp.inch = notification.getBody() as InchValueVO;
					break;
			}
		}		
	}
}