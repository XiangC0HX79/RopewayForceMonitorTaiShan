package forceMonitor.model
{
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.model.vo.RopewayForceVO;
	import forceMonitor.model.vo.RopewayVO;
	
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.DateUtil;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;

	public class RopewayForceProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayForceProxy";
		
		public function RopewayForceProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get col():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function GetForceHistory(where:String,pageIndex:Number = NaN):AsyncToken
		{
			sendNotification(ForceMonitorFacade.NOTIFY_MAIN_LOADING_SHOW,"正在统计数据...");
			
			if(isNaN(pageIndex))
			{
				return send("RopeDeteValueHis_GetList",onGetForceHistory,where);
			}
			else
			{
				var pageSize:Number = 20;
				
				var token:AsyncToken = send("RopeDeteValueHis_GetList_Page",onGetForceHistoryPage,where,pageIndex,pageSize);
				token.pageSize = pageSize;
				
				return token;			
			}
		}
		
		private function onGetForceHistory(event:ResultEvent):void
		{			
			var arr:Array = [];
			for each(var o:Object in event.result)
			{
				arr.push(new RopewayForceVO(o));
			}
			this.col.source = arr;
			
			sendNotification(ForceMonitorFacade.NOTIFY_MAIN_LOADING_HIDE);
		}
		
		private function onGetForceHistoryPage(event:ResultEvent):void
		{			
			var jd:Object = JSON.decode(String(event.result));
			
			event.token.totalCount = jd.totalCount;
			
			var arr:Array = [];
			for each(var o:Object in jd.table)
			{
				arr.push(new RopewayForceVO(o));
			}
			this.col.source = arr;
			
			sendNotification(ForceMonitorFacade.NOTIFY_MAIN_LOADING_HIDE);
		}
	}
}