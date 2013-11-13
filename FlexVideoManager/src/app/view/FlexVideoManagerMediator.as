package app.view
{
	import app.model.AreaProxy;
	import app.model.ParamProxy;
	import app.model.VideoProxy;
	
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.managers.DragManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Group;
	import spark.effects.Scale;
	
	public class FlexVideoManagerMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "FlexVideoManagerMediator";
		
		private var paramProxy:ParamProxy;
		
		public function FlexVideoManagerMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
						
			flexVideoManager.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			
			flexVideoManager.addEventListener(ResizeEvent.RESIZE,onResize);
			
			paramProxy = facade.retrieveProxy(ParamProxy.NAME) as ParamProxy;
			
			paramProxy.param.appWidth = flexVideoManager.content.width;
			paramProxy.param.appHeight = flexVideoManager.content.height;
		}
		
		protected function get flexVideoManager():FlexVideoManager
		{
			return viewComponent as FlexVideoManager;
		}
		
		private function onMouseWheel(event:MouseEvent):void
		{			
			if(event.delta > 0)
			{
				sendNotification(Notifications.IMAGE_GROUP_ZOOMIN);
			}
			else if(event.delta < 0)
			{				
				sendNotification(Notifications.IMAGE_GROUP_ZOOMOUT);
			}
		}
		
		private function onResize(event:ResizeEvent):void
		{
			paramProxy.param.appWidth = flexVideoManager.content.width;
			paramProxy.param.appHeight = flexVideoManager.content.height;
			
			sendNotification(Notifications.APP_RESIZE);
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