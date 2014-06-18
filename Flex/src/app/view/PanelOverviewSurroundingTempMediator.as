package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.InchValueVO;
	import app.model.vo.SurroundingTempVO;
	import app.view.components.PanelOverviewSurroundingTemp;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelOverviewSurroundingTempMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelOverviewSurroundingTempMediator";
		
		public function PanelOverviewSurroundingTempMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelOverviewSurroundingTemp():PanelOverviewSurroundingTemp
		{
			return viewComponent as PanelOverviewSurroundingTemp;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_SURROUDING_TEMP_FST,
				
				ApplicationFacade.ACTION_UPDATE_SURROUDING_TEMP_SND
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_SURROUDING_TEMP_FST:
					panelOverviewSurroundingTemp.fstTemp = notification.getBody() as SurroundingTempVO;
					break;
				
				case ApplicationFacade.ACTION_UPDATE_SURROUDING_TEMP_SND:
					panelOverviewSurroundingTemp.sndTemp = notification.getBody() as SurroundingTempVO;
					break;
			}
		}		
	}
}