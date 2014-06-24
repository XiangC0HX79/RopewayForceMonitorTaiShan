package app.view
{
	import mx.events.FlexEvent;
	
	import app.ApplicationFacade;
	import app.model.vo.WindVO;
	import app.view.components.ItemOverviewWind;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class ItemOverviewWindMediator extends Mediator
	{
		public static const NAME:String = "ItemOverviewWindMediator";
		
		public function ItemOverviewWindMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}
		
		protected function get itemOverviewWind():ItemOverviewWind
		{
			return viewComponent as ItemOverviewWind;
		}
		
		override public function onRegister():void
		{
			//itemOverviewWind.addEventListener(FlexEvent.ADD,onUiAdd);
			itemOverviewWind.addEventListener(FlexEvent.REMOVE,onUiRemove);
		}
				
		private function onUiRemove(event:FlexEvent):void
		{
			facade.removeMediator(mediatorName);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_WIND
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_WIND:
					var wind:WindVO = WindVO(notification.getBody());
					if((wind.bracket.ropeway.fullName == itemOverviewWind.wind.bracket.ropeway.fullName)
						&& (wind.bracket.bracketId == itemOverviewWind.wind.bracket.bracketId))
						itemOverviewWind.wind = wind;
					break;
			}
		}
	}
}