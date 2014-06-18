package forceMonitor.model
{
	import forceMonitor.model.vo.RopewayVO;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	
	public class RopewayListProxy_Old extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayListProxy";
		
		public function RopewayListProxy_Old()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get colRopeway():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function GetRopewayList():void
		{
			send("RopeDeteInfoToday_GetList",onGetRopewayList,"");
		}
		
		private function onGetRopewayList(event:ResultEvent):void
		{
			var arr:Array = [RopewayVO.ALL];
			for each(var o:ObjectProxy in event.result)
			{
				var rw:RopewayVO = new RopewayVO(o);
				arr.push(rw);
			}
			colRopeway.source = arr;
		}
	}
}