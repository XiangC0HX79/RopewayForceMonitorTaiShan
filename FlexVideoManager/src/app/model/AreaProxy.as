package app.model
{
	import app.model.vo.AreaVO;
	
	import flash.utils.Dictionary;
	
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AreaProxy extends BaseProxy implements IProxy
	{
		public static const NAME:String = "AreaProxy";
		
		public function AreaProxy()
		{
			super(NAME, new Dictionary);
		}
		
		public function get dict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function initData(unitId:Number):void
		{
			var param:Object = {};
			param.unitId = unitId;
			param.uid = Math.random();
			
			send("GetArea",param,onInitData);
		}
		
		private function onInitData(event:ResultEvent,token:Object):void
		{
			if(event.result == "")
				return;
			
			setData(new Dictionary);
			
			var jd:Array = JSON.parse(String(event.result)) as Array;			
			for each(var item:Object in jd)
			{
				var area:AreaVO = new AreaVO(item);
				dict[area.id] = area;
			}
			
			sendNotification(Notifications.INIT_DATA_AREA,dict);
		}
	}
}