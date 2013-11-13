package app.view
{
	import app.model.AreaProxy;
	import app.model.VideoProxy;
	import app.model.vo.AreaVO;
	import app.view.components.MenuGroup;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MenuGroupMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MenuGroupMediator";
		
		public function MenuGroupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			menuGroup.addEventListener(MenuGroup.RENDER_CLICK,onRenderClick);
		}
		
		protected function get menuGroup():MenuGroup
		{
			return viewComponent as MenuGroup;
		}
		
		private function onRenderClick(event:Event):void
		{
			if(menuGroup.area)
			{
				initArea(menuGroup.area);
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.INIT_DATA_AREA
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{						
			switch(notification.getName())
			{
				case Notifications.INIT_DATA_AREA:
					var arr:Array = [];
					for each(var item:AreaVO in notification.getBody())
						arr.push(item);
					menuGroup.dataProvider = new ArrayCollection(arr);
					
					if(arr.length > 0)
					{
						initArea(arr[0]);
					}
					break;
			}
		}
				
		private function initArea(area:AreaVO):void
		{
			sendNotification(Notifications.INIT_BEGIN,area);
						
			var videoProxy:VideoProxy = facade.retrieveProxy(VideoProxy.NAME) as VideoProxy;
			videoProxy.initData(area.id);
		}
	}
}