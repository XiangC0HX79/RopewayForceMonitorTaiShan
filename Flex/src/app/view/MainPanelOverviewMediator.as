package app.view
{
	import flash.events.Event;
	import flash.utils.setInterval;
	
	import mx.core.IVisualElement;
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.model.vo.RopewayStationVO;
	import app.view.components.MainPanelOverview;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class MainPanelOverviewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainPanelOverviewMediator";
		
		public function MainPanelOverviewMediator()
		{
			super(NAME, new MainPanelOverview);
		}
		
		protected function get mainPanelOverview():MainPanelOverview
		{
			return viewComponent as MainPanelOverview;
		}
		
		override public function onRegister():void
		{						
			mainPanelOverview.addEventListener(FlexEvent.ADD,onMediatorAdd);
			mainPanelOverview.addEventListener(FlexEvent.REMOVE,onMediatorRemove);
		}
		
		private function onMediatorAdd(event:FlexEvent):void
		{			
			facade.registerMediator(new PanelOverviewSurroundingMediator(mainPanelOverview.panelTemp));
			facade.registerMediator(new PanelOverviewEngineMediator(mainPanelOverview.panelEngine));
			facade.registerMediator(new PanelOverviewInchMediator(mainPanelOverview.panelInch));
			/*facade.registerMediator(new PanelOverviewForceMediator(mainPanelOverview.panelForce));*/
			facade.registerMediator(new PanelOverviewWindMediator(mainPanelOverview.panelWind));
		}
		
		private function onMediatorRemove(event:FlexEvent):void
		{			
			facade.removeMediator(PanelOverviewSurroundingMediator.NAME);
			facade.removeMediator(PanelOverviewEngineMediator.NAME);
			facade.removeMediator(PanelOverviewInchMediator.NAME);
			/*facade.removeMediator(PanelOverviewForceMediator.NAME);*/
			facade.removeMediator(PanelOverviewWindMediator.NAME);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
			}
		}
	}
}