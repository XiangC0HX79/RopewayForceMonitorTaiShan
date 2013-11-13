package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.WheelHistoryVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.*;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class WheelHistoryProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "WheelHistoryProxy";
		
		public static var MaintainType:ArrayCollection = new ArrayCollection();
		
		public function WheelHistoryProxy(data:Object=null)
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get wheelDict():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function InitWheelHistory(id:String):void
		{
			var where:String = "WheelId = '" + id + "' order by MaintainTime desc";
			send("T_ME_WheelMaintainData_GetModelList",onInitWheelDict,where);
		}
		
		private function onInitWheelDict(event:ResultEvent):void
		{
			var arr:ArrayCollection = new ArrayCollection();
			for each(var obj:* in event.result)
			{
				var wh:WheelHistoryVO = new WheelHistoryVO(obj);
				for each(var o:Object in MaintainType)
				{
					if(wh.MaintainType == o.DicId)
						wh.MaintainType = o.DicValue;
				}
				arr.addItem(wh);
			}
			
			sendNotification(ApplicationFacade.NOTIFY_WHEELHISTORY_COMPLETE,arr);
		}
		
		public function AddWheelHistory(wh:Object):void
		{
			var token:AsyncToken = send("T_ME_WheelMaintainData_Add",onAddWheelHistory,JSON.stringify(wh.valueOf()).toString());
			token.info = wh;
		}
		
		private function onAddWheelHistory(event:ResultEvent):void
		{
			
			sendNotification(ApplicationFacade.NOTIFY_ADD_MAINTAIN);
		}
		
		public function EditWheelHistory(wh:Object):void
		{
			var token:AsyncToken = send("T_ME_WheelMaintainData_Update",onAddWheelHistory,JSON.stringify(wh.valueOf()).toString());
			token.info = wh;
		}
		
		public function DeleteWheelHistory(id:int):void
		{
			send("T_ME_WheelMaintainData_Delete",onDeleteWheelHistory,id);
		}
		
		private function onDeleteWheelHistory(event:ResultEvent):void
		{
			sendNotification(ApplicationFacade.NOTIFY_DELETE_MAINTAIN);
		}
	}
}