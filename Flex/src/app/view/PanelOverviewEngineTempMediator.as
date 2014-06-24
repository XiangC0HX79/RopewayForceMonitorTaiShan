package app.view
{
	import app.ApplicationFacade;
	import app.model.vo.EngineTempVO;
	import app.model.vo.EngineVO;
	import app.model.vo.SurroundingTempVO;
	import app.view.components.PanelOverviewEngine;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelOverviewEngineTempMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelOverviewEngineTempMediator";
		
		public function PanelOverviewEngineTempMediator(viewComponent:Object=null)
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
				ApplicationFacade.ACTION_UPDATE_ENGINE_FST,
				
				ApplicationFacade.ACTION_UPDATE_ENGINE_SND
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_ENGINE_FST:
					panelOverviewEngineTemp.fstTemp = (notification.getBody() as EngineVO).lastTemp;
					break;
				
				case ApplicationFacade.ACTION_UPDATE_ENGINE_SND:
					panelOverviewEngineTemp.sndTemp = (notification.getBody() as EngineVO).lastTemp;
					break;
			}
		}		
	}
}