package app.view
{
	import app.model.VideoProxy;
	import app.model.vo.VideoVO;
	import app.view.components.TipGroup;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TipGroupMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TipGroupMediator";
		
		public function TipGroupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			tipGroup.addEventListener(TipGroup.SAVE,onSave);
		}
		
		protected function get tipGroup():TipGroup
		{
			return viewComponent as TipGroup;
		}
		
		private function onSave(event:Event):void
		{
			tipGroup.video.title = tipGroup.txtTitle.text;
			tipGroup.video.info = tipGroup.txtInfo.text;
			
			var videoProxy:VideoProxy  = facade.retrieveProxy(VideoProxy.NAME) as VideoProxy;
			videoProxy.updateVideo(tipGroup.video);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.VIDEO_SHOW_TIP,
				Notifications.IMAGE_GROUP_REFRESH
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{						
			switch(notification.getName())
			{
				case Notifications.VIDEO_SHOW_TIP:
					showTip(notification.getBody()[0],notification.getBody()[1]);
					break;
				
				case Notifications.IMAGE_GROUP_REFRESH:
					tipGroup.visible = false;
					break;
			}
		}
		
		private function showTip(video:VideoVO,pt:Point):void
		{
			tipGroup.video = video.clone();
			
			var offset:Number = 20;
			if(pt.x > tipGroup.width + offset + 10)
			{
				tipGroup.x = pt.x - tipGroup.width - offset;
			}
			else
			{
				tipGroup.x = pt.x + offset;
			}
			
			if(pt.y > tipGroup.height + offset + 10)
			{
				tipGroup.y = pt.y - tipGroup.height - offset;
			}
			else
			{
				tipGroup.y = pt.y + offset;
			}
			
			tipGroup.visible = true;
		}
	}
}