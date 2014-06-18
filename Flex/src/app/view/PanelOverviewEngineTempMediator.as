package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.EngineTempVO;
	import app.model.vo.SurroundingTempVO;
	import app.view.components.PanelOverviewEngineTemp;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelOverviewEngineTempMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelOverviewEngineTempMediator";
		
		public function PanelOverviewEngineTempMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelOverviewEngineTemp():PanelOverviewEngineTemp
		{
			return viewComponent as PanelOverviewEngineTemp;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_ENGINE_TEMP_FST,
				
				ApplicationFacade.ACTION_UPDATE_ENGINE_TEMP_SND
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_ENGINE_TEMP_FST:
					panelOverviewEngineTemp.fstTemp = notification.getBody() as EngineTempVO;
					break;
				
				case ApplicationFacade.ACTION_UPDATE_ENGINE_TEMP_SND:
					panelOverviewEngineTemp.sndTemp = notification.getBody() as EngineTempVO;
					break;
			}
		}		
	}
}