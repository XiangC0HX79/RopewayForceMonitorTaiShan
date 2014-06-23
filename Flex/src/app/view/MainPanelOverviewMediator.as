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
			
			mainPanelOverview.addEventListener(FlexEvent.ADD,onMediatorAdd);
			mainPanelOverview.addEventListener(FlexEvent.REMOVE,onMediatorRemove);
		}
		
		protected function get mainPanelOverview():MainPanelOverview
		{
			return viewComponent as MainPanelOverview;
		}
		
		private function onMediatorAdd(event:FlexEvent):void
		{
			facade.registerMediator(new PanelOverviewSurroundingTempMediator(mainPanelOverview.panelTemp));
			facade.registerMediator(new PanelOverviewEngineTempMediator(mainPanelOverview.panelEngine));
			facade.registerMediator(new PanelOverviewInchMediator(mainPanelOverview.panelInch));
			facade.registerMediator(new PanelOverviewForceMediator(mainPanelOverview.panelForce));
		}
		
		private function onMediatorRemove(event:FlexEvent):void
		{			
			facade.removeMediator(PanelOverviewSurroundingTempMediator.NAME);
			facade.removeMediator(PanelOverviewInchMediator.NAME);
			facade.removeMediator(PanelOverviewEngineTempMediator.NAME);
			facade.removeMediator(PanelOverviewForceMediator.NAME);
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