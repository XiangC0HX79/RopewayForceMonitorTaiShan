package app.view
{
	import app.ApplicationFacade;
	import app.model.WheelManageProxy;
	import app.model.vo.AreaWheelVO;
	import app.model.vo.WheelInsertVO;
	import app.model.vo.WheelManageVO;
	import app.view.components.TitleWindowManage;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.utils.*;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TitleWindowManageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TitleWindowManageMediator";
		
		public function TitleWindowManageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			titleWindowManage.addEventListener(titleWindowManage.BASEINFO_ADD,Onadd);
			titleWindowManage.addEventListener(titleWindowManage.BASEINFO_DELETE,OnDelete);
			titleWindowManage.addEventListener(TitleWindowManage.BASEINFO_EDIT,OnEdit);
		}
		
		protected function get titleWindowManage():TitleWindowManage
		{
			return viewComponent as TitleWindowManage;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_WHEELMANAGE_COMPLETE,
				ApplicationFacade.NOTIFY_ADD_WHEELMANAGE,
				ApplicationFacade.NOTIFY_DELETE_WHEELMANAGE,
				ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE
			];
		}
		
		private var standArr:ArrayCollection = new ArrayCollection();
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_WHEELMANAGE_COMPLETE:
					var arr:ArrayCollection = notification.getBody() as ArrayCollection;
					titleWindowManage.datagrid.dataProvider = arr;
					titleWindowManage.addEventListener(CloseEvent.CLOSE,OnClose);
					break;
				case ApplicationFacade.NOTIFY_ADD_WHEELMANAGE:
					var wheelManageProxy:WheelManageProxy = facade.retrieveProxy(WheelManageProxy.NAME) as WheelManageProxy;
					wheelManageProxy.InitWheelManage(titleWindowManage.baseInfo.AreaId);
					sendNotification(ApplicationFacade.NOTIFY_INIT_STATION_CHANGE);
					//wheelManageProxy.InitWheel(titleWindowManage.baseInfo.AreaId);
					break;
				case ApplicationFacade.NOTIFY_DELETE_WHEELMANAGE:
					var wheelManageProxy2:WheelManageProxy = facade.retrieveProxy(WheelManageProxy.NAME) as WheelManageProxy;
					wheelManageProxy2.InitWheelManage(titleWindowManage.baseInfo.AreaId);
					//wheelManageProxy2.InitWheel(titleWindowManage.baseInfo.AreaId);
					break;
				case ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE:
					standArr = notification.getBody() as ArrayCollection;
					break;
			}
		}
		
		private function Onadd(event:Event):void
		{
			if(titleWindowManage.t_wheelId.text != "")
			{ 
				var nn:int = 0;
				for each(var wm:WheelManageVO in standArr)
				{
					if(wm.WheelId == titleWindowManage.t_wheelId.text)
					{
						nn++;
					}
				}
				if(nn==0)
				{
					var wheelManageProxy:WheelManageProxy = facade.retrieveProxy(WheelManageProxy.NAME) as WheelManageProxy;
					var obj:* = {};
					obj.WheelId = titleWindowManage.t_wheelId.text;
					obj.LineAreaId = titleWindowManage.baseInfo.AreaId;
					obj.RopeWay = titleWindowManage.listRopeway.text;
					obj.WheelType = (titleWindowManage.listStandType.selectedIndex + 1).toString();
						
					var wm2:WheelInsertVO = new WheelInsertVO(obj);
					wheelManageProxy.AddWheelManage(wm2);
				}
				else
				{
					Alert.show("输入的滚轮编号已存在！");
				}
			}
			else
			{
				Alert.show("请输入滚轮编号！");
			}
		}
		
		private function OnDelete(event:Event):void
		{
			if(titleWindowManage.datagrid.selectedItem != null)
			{
				Alert.show("是否删除信息？","",(Alert.YES | Alert.NO),null,onBaseInfoDelConfirm);
				function onBaseInfoDelConfirm(event:CloseEvent):void
				{
					if(event.detail == Alert.YES)
					{
						var wm:WheelManageVO = titleWindowManage.datagrid.selectedItem as WheelManageVO;
						
						var w:WheelInsertVO = new WheelInsertVO(wm);
						//w.WheelId = titleWindowManage.t_wheelId.text;
						w.Is_Delete = 1;
						
						titleWindowManage.t_wheelId.text = "";
						
						var wheelManageProxy:WheelManageProxy = facade.retrieveProxy(WheelManageProxy.NAME) as WheelManageProxy;
						wheelManageProxy.DeleteWheelManage(w);
					}
				}
			}
			else
			{
				Alert.show("请选择要删除的滚轮！");
			}
		}
		
		private function OnEdit(event:Event):void
		{
			if(titleWindowManage.t_wheelId.text != "")
			{ 
				var nn:int = 0;
				for each(var wm:WheelManageVO in standArr)
				{
					if(wm.WheelId == titleWindowManage.t_wheelId.text && wm.WheelId !=titleWindowManage.datagrid.selectedItem.WheelId)
					{
						nn++;
					}
				}
				if(nn==0)
				{
					wm = titleWindowManage.datagrid.selectedItem as WheelManageVO;
					
					var w:WheelInsertVO = new WheelInsertVO(wm);
					w.WheelType = (titleWindowManage.listStandType.selectedIndex + 1).toString();
					w.WheelId = titleWindowManage.t_wheelId.text;
					var wheelManageProxy:WheelManageProxy = facade.retrieveProxy(WheelManageProxy.NAME) as WheelManageProxy;
					wheelManageProxy.DeleteWheelManage(w);
					titleWindowManage.t_wheelId.text = "";
				}
				else
				{
					Alert.show("输入的滚轮编号已存在！");
				}
			}
			else
			{
				Alert.show("请输入滚轮编号！");
			}
		}
		
		private function OnClose(event:CloseEvent):void
		{
			//sendNotification(ApplicationFacade.NOTIFY_INIT_STATION_CHANGE);
		}
	}
}