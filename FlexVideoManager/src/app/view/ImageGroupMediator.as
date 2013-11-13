package app.view
{
	import app.model.AreaProxy;
	import app.model.ParamProxy;
	import app.model.VideoProxy;
	import app.model.vo.AreaVO;
	import app.model.vo.ParamVO;
	import app.model.vo.VideoVO;
	import app.view.components.ImageGroup;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.core.IVisualElement;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.managers.CursorManager;
	import mx.managers.DragManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ImageGroupMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ImageGroupMediator";
		
		[Embed('assets/image/cam_add.png')]		
		private static const CURSOR_ADD:Class;
		
		[Embed('assets/image/cam_del.png')]		
		private static const CURSOR_DEL:Class;
		
		private var contentWidth:Number = 0;
		private var contentHeight:Number = 0;
		
		private var paramProxy:ParamProxy;
		private var videoProxy:VideoProxy;
		
		public function ImageGroupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);		
			
			imageGroup.addEventListener(FlexEvent.READY,onImageReady);
			
			imageGroup.addEventListener(MouseEvent.ROLL_OVER,onRollOver);	
			imageGroup.addEventListener(MouseEvent.ROLL_OUT,onRollOut);		
			
			imageGroup.addEventListener(MouseEvent.MOUSE_DOWN,image_mouseDownHandler);
			imageGroup.addEventListener(MouseEvent.MOUSE_MOVE,image_mouseMoveHandler);
			
			imageGroup.addEventListener(MouseEvent.CLICK,onClick);
			
			imageGroup.addEventListener(DragEvent.DRAG_ENTER,onDragEnter);
			imageGroup.addEventListener(DragEvent.DRAG_DROP,onDragDrop);
			
			paramProxy = facade.retrieveProxy(ParamProxy.NAME) as ParamProxy;	
			videoProxy = facade.retrieveProxy(VideoProxy.NAME) as VideoProxy;
		}
		
		protected function get imageGroup():ImageGroup
		{
			return viewComponent as ImageGroup;
		}
		
		private function onImageReady(event:FlexEvent):void
		{
			contentWidth = imageGroup.img.sourceWidth;
			contentHeight = imageGroup.img.sourceHeight;
			
			imageGroup.width = contentWidth;
			imageGroup.height = contentHeight;
			
			sizeToContent();
			
			sendNotification(Notifications.INIT_VIEW_IMAGE);
		}
		
		private function onRollOver(event:MouseEvent):void
		{						
			if(paramProxy.param.status == ParamVO.STATUS_CAM_ADD)
			{
				CursorManager.setCursor(CURSOR_ADD,2,-14 ,-16);	
			}
			else if(paramProxy.param.status == ParamVO.STATUS_CAM_DEL)
			{
				CursorManager.setCursor(CURSOR_DEL,2,-14 ,-16);	
			}
		}
		
		private function onRollOut(event:MouseEvent):void
		{
			CursorManager.removeAllCursors();
		}		
		
		private function onClick(event:MouseEvent):void
		{				
			if(paramProxy.param.status == ParamVO.STATUS_CAM_ADD)
			{
				if((mc.x == event.localX)
					&& (mc.y == event.localY))
				{
					var areaProxy:AreaProxy = facade.retrieveProxy(AreaProxy.NAME) as AreaProxy;
					videoProxy.addVideo(imageGroup.area.id,event.localX,event.localY);
				}
			}
		}
		
		private function onDragEnter(e:DragEvent):void
		{			
			if(
				e.dragSource.hasFormat("VideoVO")	
			)
			{ 
				DragManager.acceptDragDrop(imageGroup);	
			}  
		}
		
		private function onDragDrop(e:DragEvent):void
		{			
			var sp:Point = e.dragSource.dataForFormat("StartPoint") as Point;
			
			if(e.dragSource.hasFormat("VideoVO"))
			{  
				var v:VideoVO = (e.dragSource.dataForFormat("VideoVO") as VideoVO).clone();
				v.X = e.localX - sp.x + e.dragInitiator.width / 2;
				v.Y = e.localY - sp.y + e.dragInitiator.height / 2;
				
				videoProxy.updateVideo(v);	
			}
		}
		
		
		private function zoomin():void
		{
			var s:Number = Math.floor(imageGroup.scaleX*10) / 10;
			zoom(s+0.1);
		}
		
		private function zoomout():void
		{
			var s:Number = Math.floor(imageGroup.scaleX*10) / 10;
			if(s > 0)
				zoom(s-0.1);
		}
				
		protected function sizeToContent():void
		{
			var s:Number = Math.min(paramProxy.param.appWidth / contentWidth,paramProxy.param.appHeight / contentHeight);
			
			zoom(s);
		}
		
		private function zoom(s:Number):void
		{
			var oldScale:Number = imageGroup.scaleX;
			var zoomPoint:Point = new Point(paramProxy.param.appWidth / 2,paramProxy.param.appHeight / 2);
			
			imageGroup.scaleX = s;
			imageGroup.scaleY = s;
			
			var scaleW:Number = contentWidth * imageGroup.scaleX;
			var scaleH:Number = contentHeight * imageGroup.scaleY;
			
			if(paramProxy.param.appWidth >= scaleW)
			{
				imageGroup.x = int((paramProxy.param.appWidth - scaleW) / 2);
			}
			else if((imageGroup.x - zoomPoint.x)/oldScale*s + zoomPoint.x > 0)
			{
				imageGroup.x = 0;
			}
			else if((imageGroup.x + scaleW - zoomPoint.x)/oldScale*s + zoomPoint.x < paramProxy.param.appWidth)
			{
				imageGroup.x = paramProxy.param.appWidth - scaleW;
			}
			else
			{
				
				imageGroup.x = (imageGroup.x - zoomPoint.x)/oldScale*s + zoomPoint.x ;
			}
			
			if(paramProxy.param.appHeight >= scaleH)
			{
				imageGroup.y = int((paramProxy.param.appHeight - scaleH) / 2);
			}
			else if((imageGroup.y - zoomPoint.y)/oldScale*s + zoomPoint.y > 0)
			{
				imageGroup.y= 0;
			}
			else if((imageGroup.y + scaleH - zoomPoint.y)/oldScale*s + zoomPoint.y < paramProxy.param.appHeight)
			{
				imageGroup.y= paramProxy.param.appHeight - scaleH;
			}
			else
			{					
				imageGroup.y = (imageGroup.y - zoomPoint.y)/oldScale*s + zoomPoint.y;
			} 
		}
		
		private var mc:Point;
		private var srcPoint:Point;
		protected function image_mouseDownHandler(event:MouseEvent):void
		{
			mc = new Point(event.localX,event.localY);
			srcPoint = new Point(event.stageX,event.stageY);
		}
		
		protected function image_mouseMoveHandler(event:MouseEvent):void
		{
			if(event.buttonDown && !DragManager.isDragging)
			{					
				var desPoint:Point = new Point(event.stageX,event.stageY);
				
				var tempPoint:Point = new Point(imageGroup.x + (desPoint.x - srcPoint.x)*imageGroup.scaleX
					,imageGroup.y + (desPoint.y - srcPoint.y)*imageGroup.scaleY);
				
				var imageW:Number = imageGroup.width * imageGroup.scaleX;
				var imageH:Number = imageGroup.height * imageGroup.scaleY;
				
				if(paramProxy.param.appWidth < imageW)
				{
					if(tempPoint.x > 0)
					{
						imageGroup.x = 0;
					}
					else if(tempPoint.x < paramProxy.param.appWidth - imageW)
					{
						imageGroup.x = paramProxy.param.appWidth - imageW;
					}
					else
					{
						imageGroup.x = tempPoint.x;
					}		
				}
				
				if(paramProxy.param.appHeight < imageH)
				{
					if(tempPoint.y > 0)
					{
						imageGroup.y = 0;
					}
					else if(tempPoint.y < paramProxy.param.appHeight - imageH)
					{
						imageGroup.y = paramProxy.param.appHeight - imageH;
					}
					else
					{
						imageGroup.y = tempPoint.y;
					}	
				}
				
				srcPoint.x = desPoint.x;
				srcPoint.y = desPoint.y; 
			}
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				Notifications.APP_RESIZE,
				
				Notifications.INIT_BEGIN,
				
				Notifications.INIT_END,
				
				Notifications.IMAGE_GROUP_REFRESH,
				
				Notifications.IMAGE_GROUP_ZOOMCONTENT,
				Notifications.IMAGE_GROUP_ZOOMIN,
				Notifications.IMAGE_GROUP_ZOOMOUT,
				Notifications.IMAGE_GROUP_ZOOMREAL
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{						
			switch(notification.getName())
			{
				case Notifications.APP_RESIZE:
					zoom(imageGroup.scaleX);
					break;
				
				case Notifications.INIT_BEGIN:
					imageGroup.area = notification.getBody() as AreaVO;
					break;
				
				case Notifications.INIT_END:
					refreshVideo();
					break;
								
				case Notifications.IMAGE_GROUP_REFRESH:
					refreshVideo();
					break;
				
				case Notifications.IMAGE_GROUP_ZOOMCONTENT:
					sizeToContent();
					break;
				
				case Notifications.IMAGE_GROUP_ZOOMIN:
					zoomin();
					break;
				
				case Notifications.IMAGE_GROUP_ZOOMOUT:
					zoomout();
					break;
				
				case Notifications.IMAGE_GROUP_ZOOMREAL:
					zoom(1);
					break;
			}
		}
		
		private function refreshVideo():void
		{
			imageGroup.layerVideo.removeAllElements();
			for each(var item:VideoVO in videoProxy.dict)
			{
				var imageVideoMediator:ImageVideoMediator = new ImageVideoMediator(item);
				facade.registerMediator(imageVideoMediator);
				imageGroup.layerVideo.addElement(imageVideoMediator.getViewComponent() as IVisualElement);
			}
		}
	}
}