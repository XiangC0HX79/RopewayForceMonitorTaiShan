package app.view
{
	import app.ApplicationFacade;
	import app.view.components.WheelGroup;
	
	import mx.collections.ArrayCollection;
	
	import custom.itemRenderer.ItemRendererAreaDetection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class WheelGroupMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "WheelGroupMediator";
		
		public function WheelGroupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get wheelGroup():WheelGroup
		{
			return viewComponent as WheelGroup;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_AREAWHEEL_COMPLETE
			];
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_AREAWHEEL_COMPLETE:			
					/*var arr:ArrayCollection = notification.getBody() as ArrayCollection;
					
					wheelGroup.dataProvider = arr;*/
					break;
			}
		}
	}
}