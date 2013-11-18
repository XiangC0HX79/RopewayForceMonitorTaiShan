package app.model
{
	import app.model.vo.VideoVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class VideoProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = "VideoProxy";
		
		public function VideoProxy()
		{
			super(NAME, new Dictionary);
		}
		
		public function get dict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function initData(areaId:Number):void
		{			
			var param:Object = {};
			param.areaId = areaId;
			param.uid = Math.random();
			
			send("GetVideo",param,onInitData);
		}
		
		private function onInitData(event:ResultEvent,token:AsyncToken):void
		{			
			if(event.result == "")
				return;
			
			setData(new Dictionary);
			
			var jd:Array = JSON.parse(String(event.result)) as Array;
			for each(var item:Object in jd)
			{				
				var video:VideoVO = new VideoVO(item);
				dict[video.id] = video;
			}
			
			sendNotification(Notifications.INIT_DATA_VIDEO,dict);
		}
		
		public function addVideo(areaId:Number,x:Number,y:Number):void
		{
			var video:VideoVO = new VideoVO({});
			video.id = 0;
			video.areaId = areaId;
			video.X = x;
			video.Y = y;
			video.title = "";
			video.info = "";
						
			var param:Object = {};
			param.json = JSON.stringify(video);
			param.uid = Math.random();
			
			var token:AsyncToken = send("NewVideo",param,onAddVideo);
			token.video = video;
		}
		
		private function onAddVideo(event:ResultEvent,token:Object):void
		{
			if(event.result > 0)
			{
				var video:VideoVO = event.token.video as VideoVO;
				video.id = Number(event.result);
				
				dict[video.id] = video;
				
				sendNotification(Notifications.NOTIFY_ALERT_INFO,"摄像头添加成功。");
				
				sendNotification(Notifications.IMAGE_GROUP_REFRESH,dict);
			}
		}
		
		public function delVideo(video:VideoVO):void
		{
			var param:Object = {};
			param.json = JSON.stringify(video);
			param.uid = Math.random();
			
			var token:AsyncToken = send("DelVideo",param,onDelVideo);
			token.video = video;
		}
		
		private function onDelVideo(event:ResultEvent,token:Object):void
		{			
			if(event.result)
			{
				var video:VideoVO = event.token.video as VideoVO;
				
				delete dict[video.id];
				
				sendNotification(Notifications.IMAGE_GROUP_REFRESH,dict);
			}
		}
		
		public function updateVideo(video:VideoVO):void
		{
			var param:Object = {};
			param.json = JSON.stringify(video);
			param.uid = Math.random();
			
			var token:AsyncToken = send("UpdateVideo",param,onUpdateVideo);
			token.video = video;
		}
		
		private function onUpdateVideo(event:ResultEvent,token:Object):void
		{			
			if(event.result)
			{
				var video:VideoVO = event.token.video as VideoVO;
				
				dict[video.id] = video;
				
				sendNotification(Notifications.NOTIFY_ALERT_INFO,"摄像头信息更新成功。");
				
				sendNotification(Notifications.IMAGE_GROUP_REFRESH,dict);
			}
		}
	}
}