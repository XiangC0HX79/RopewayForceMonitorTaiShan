package app.view
{
	import app.model.ParamProxy;
	import app.model.VideoProxy;
	import app.model.vo.ParamVO;
	import app.model.vo.VideoVO;
	import app.view.components.ImageVideo;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	
	import mx.core.DragSource;
	import mx.events.FlexEvent;
	import mx.managers.DragManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Image;
	
	public class ImageVideoMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ImageVideoMediator";
		
		private var paramProxy:ParamProxy;
		private var videoProxy:VideoProxy;
		
		public function ImageVideoMediator(video:VideoVO)
		{
			super(NAME + video.id, new ImageVideo);
			
			imageVideo.addEventListener(FlexEvent.REMOVE,onImageRemove);
			
			paramProxy = facade.retrieveProxy(ParamProxy.NAME) as ParamProxy;
			videoProxy = facade.retrieveProxy(VideoProxy.NAME) as VideoProxy;
			
			if(paramProxy.param.edited)
			{
				imageVideo.addEventListener(MouseEvent.MOUSE_MOVE,onDragStart);
				imageVideo.addEventListener(MouseEvent.CLICK,onClickEdit);
			}
			else
			{
				imageVideo.addEventListener(MouseEvent.CLICK,onClickView);				
			}
			
			imageVideo.v = video;
		}
		
		protected function get imageVideo():ImageVideo
		{
			return viewComponent as ImageVideo;
		}
		
		private function onImageRemove(event:Event):void
		{
			facade.removeMediator(this.mediatorName);
		}
		
		private function onClickView(event:MouseEvent):void
		{
			ExternalInterface.call("naviVideo",imageVideo.v.title,imageVideo.v.info);
		}
		
		private function onClickEdit(event:MouseEvent):void
		{		
			event.stopPropagation();
				
			if(paramProxy.param.status == ParamVO.STATUS_CAM_DEL)
			{
				videoProxy.delVideo(imageVideo.v);
			}
			else
			{
				var pt:Point = imageVideo.localToGlobal(new Point(imageVideo.width / 2,imageVideo.height / 2));
				sendNotification(Notifications.VIDEO_SHOW_TIP,[imageVideo.v,pt]);
			}
		}
		
		private function onDragStart(e:MouseEvent):void
		{									
			var imageProxy:Image = new Image;
			imageProxy.source = imageVideo.source;
			
			var ds:DragSource = new DragSource();  
			ds.addData(imageVideo.v,"VideoVO");
			ds.addData(new Point(e.localX,e.localY),"StartPoint");
			DragManager.doDrag(imageVideo,ds,e,imageProxy); 
		}	
	}
}