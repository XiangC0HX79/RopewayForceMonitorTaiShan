package app.view
{
	import flash.events.Event;
	
	import mx.events.ResizeEvent;
	
	import app.ApplicationFacade;
	import app.model.vo.WindVO;
	import app.view.components.ItemOverviewWind;
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
		
		private function updateWind(wind:WindVO):void
		{
			var index:int = 0;
			
			for(var i:int = 0;i<panelOverviewWind.mainContent.numElements;i++)
			{
				var iow:ItemOverviewWind = ItemOverviewWind(panelOverviewWind.mainContent.getElementAt(i));
				if(iow.wind.bracket.bracketId > wind.bracket.bracketId)
				{
					break;
				}
				else if(iow.wind.bracket.bracketId == wind.bracket.bracketId)
				{
					index = -1;
					break;
				}
				else
				{
					index = i + 1;					
				}
			}
			
			if(index >= 0)
			{
				iow = new ItemOverviewWind;
				iow.wind = wind;
				
				panelOverviewWind.mainContent.addElementAt(iow,index);
				panelOverviewWind.mainContent.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
				facade.registerMediator(new ItemOverviewWindMediator(ItemOverviewWindMediator.NAME + iow.uid,iow));
			}
		}
		
		private function refreshWind(winds:Array):void
		{
			panelOverviewWind.mainContent.removeAllElements();
			
			for each(var wind:WindVO in winds)
			{				
				var iow:ItemOverviewWind = new ItemOverviewWind;
				iow.wind = wind;
				
				panelOverviewWind.mainContent.addElement(iow);
				facade.registerMediator(new ItemOverviewWindMediator(ItemOverviewWindMediator.NAME + iow.uid,iow));
			}
			
			panelOverviewWind.mainContent.dispatchEvent(new ResizeEvent(ResizeEvent.RESIZE));
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_WIND,
				
				ApplicationFacade.ACTION_REFRESH_WIND
				];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_WIND:
					updateWind(WindVO(notification.getBody()));
					break;
				
				case ApplicationFacade.ACTION_REFRESH_WIND:
					refreshWind(notification.getBody() as Array);
					break;
			}
		}
	}
}