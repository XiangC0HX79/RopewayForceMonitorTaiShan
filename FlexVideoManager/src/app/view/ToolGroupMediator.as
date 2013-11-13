package app.view
{
	import app.model.ParamProxy;
	import app.model.vo.ParamVO;
	import app.view.components.ToolGroup;
	
	import flash.events.Event;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ToolGroupMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ToolGroupMediator";
		
		private var paramProxy:ParamProxy;
		
		public function ToolGroupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			toolGroup.addEventListener(ToolGroup.ZOOM_OUT,onZoomOut);
			toolGroup.addEventListener(ToolGroup.ZOOM_IN,onZoomIn);
			toolGroup.addEventListener(ToolGroup.SIZE_TURE,onSizeTrue);
			toolGroup.addEventListener(ToolGroup.SIZE_CONTENT,onSizeContent);
			
			toolGroup.addEventListener(ToolGroup.DEFUALT,onDefault);
			toolGroup.addEventListener(ToolGroup.CAM_ADD,onCamAdd);
			toolGroup.addEventListener(ToolGroup.CAM_DEL,onCamDel);
			
			paramProxy = facade.retrieveProxy(ParamProxy.NAME) as ParamProxy;
			
			if(paramProxy.param.edited)
			{
				toolGroup.currentState = "edit";
			}
		}
		
		protected function get toolGroup():ToolGroup
		{
			return viewComponent as ToolGroup;
		}
		
		private function onZoomOut(event:Event):void
		{
			sendNotification(Notifications.IMAGE_GROUP_ZOOMOUT);
		}
		
		private function onZoomIn(event:Event):void
		{
			sendNotification(Notifications.IMAGE_GROUP_ZOOMIN);
		}
		
		private function onSizeTrue(event:Event):void
		{
			sendNotification(Notifications.IMAGE_GROUP_ZOOMREAL);
		}
		
		private function onSizeContent(event:Event):void
		{
			sendNotification(Notifications.IMAGE_GROUP_ZOOMCONTENT);
		}
		
		private function onDefault(event:Event):void
		{
			paramProxy.param.status = ParamVO.STATUS_DEFUALT;
		}
		
		private function onCamAdd(event:Event):void
		{
			paramProxy.param.status = ParamVO.STATUS_CAM_ADD;
		}
		
		private function onCamDel(event:Event):void
		{
			paramProxy.param.status = ParamVO.STATUS_CAM_DEL;
		}
	}
}