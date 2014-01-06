package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.WheelInsertVO;
	import app.model.vo.WheelManageVO;
	
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.*;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class WheelManageProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "WheelManageProxy";
		
		public function WheelManageProxy(data:Object=null)
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get wheelDict():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function InitWheel(id:int):void
		{
			var where:String = "LineAreaId = '" + id + "' and RopeWay = '" + FlexGlobals.topLevelApplication.Station + "'";
			send("T_ME_LineBracketAreaWheelData_GetModelList",onInitWheelDict,where);
		}
		
		public function InitAllWheel(station:String):void
		{
			var where:String = "RopeWay = '" + station + "'";
			send("T_ME_LineBracketAreaWheelData_GetModelList",onInitAllWheelDict,"");
		}
		
		private function onInitAllWheelDict(event:ResultEvent):void
		{
			//var arr:ArrayCollection = new ArrayCollection();
			wheelDict.removeAll();
			for each(var obj:* in event.result)
			{
				var wh:WheelManageVO = new WheelManageVO(obj);
				wheelDict.addItem(wh);
			}
			send("T_MT_InquireAboutHolder_GetModelList",onInitAllWarnDict,"");
			function  onInitAllWarnDict(event:ResultEvent):void
			{
				for each(var obj:* in event.result)
				{
					for each(var wm:WheelManageVO in wheelDict)
					{
						if(wm.WheelId == obj.WheelId)
						{
							if(obj.Color == "#FFD700")
								wm.Status = "yellow";
							else if(obj.Color == "#FF0000")
								wm.Status = "red";
							else
								wm.Status = "black";
						}
					}
				}
				sendNotification(ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE,wheelDict);
			}
		}
		
		private function onInitWheelDict(event:ResultEvent):void
		{
			var arr:ArrayCollection = new ArrayCollection();
			for each(var obj:* in event.result)
			{
				var wh:WheelManageVO = new WheelManageVO(obj);
				arr.addItem(wh);
			}
			
			//sendNotification(ApplicationFacade.NOTIFY_WHEELLIST_COMPLETE,arr);
		}
		
		public function InitWheelManage(id:int):void
		{
			var where:String = "LineAreaId = '" + id + "' and RopeWay = '" + FlexGlobals.topLevelApplication.Station + "'";
			send("T_ME_LineBracketAreaWheelData_GetModelList",onInitWheelManageDict,where);
		}
		
		private function onInitWheelManageDict(event:ResultEvent):void
		{
			var arr:ArrayCollection = new ArrayCollection();
			for each(var obj:* in event.result)
			{
				var wh:WheelManageVO = new WheelManageVO(obj);
				if(wh.Is_Delete == 0)
					arr.addItem(wh);
			}
			
			sendNotification(ApplicationFacade.NOTIFY_WHEELMANAGE_COMPLETE,arr);
		}
		
		public function AddWheelManage(wm:WheelInsertVO):void
		{
			var token:AsyncToken = send("T_ME_LineBracketAreaWheelData_Add",onAddWheelManage,JSON.stringify(wm.obj));
			token.info = wm;
		}
		
		private function onAddWheelManage(event:ResultEvent):void
		{			
			sendNotification(ApplicationFacade.NOTIFY_ADD_WHEELMANAGE);
		}
		
		
		public function DeleteWheelManage(wm:WheelInsertVO):void
		{
			send("T_ME_LineBracketAreaWheelData_Update",onDeleteWheelManage,JSON.stringify(wm.obj));
		}
		
		private function onDeleteWheelManage(event:ResultEvent):void
		{
			sendNotification(ApplicationFacade.NOTIFY_DELETE_WHEELMANAGE);
			sendNotification(ApplicationFacade.NOTIFY_INIT_STATION_CHANGE);
		}
	}
}