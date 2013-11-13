package app.view
{
	import app.ApplicationFacade;
	import app.model.AreaWheelProxy;
	import app.model.MaintainTypeProxy;
	import app.model.WheelHistoryProxy;
	import app.model.WheelManageProxy;
	import app.model.WheelProxy;
	import app.model.vo.AreaWheelVO;
	import app.model.vo.WheelHistoryVO;
	import app.model.vo.WheelManageVO;
	import app.model.vo.WheelVO;
	import app.view.components.AreaTitleWindow;
	import app.view.components.TitleWindowBaseInfo;
	import app.view.components.TitleWindowManage;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.core.IVisualElement;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.rpc.events.ResultEvent;
	import mx.utils.*;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AreaTitleWindowMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "AreaTitleWindowMediator";
		
		public function AreaTitleWindowMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			areaTitleWindow.addElement(facade.retrieveMediator(WheelGroupMediator.NAME).getViewComponent() as IVisualElement);
			areaTitleWindow.addbn.addEventListener(FlexEvent.BUTTON_DOWN,OnAdd);
			areaTitleWindow.addEventListener(AreaTitleWindow.MAINTAIN_EDIT,OnEdit);
			areaTitleWindow.addEventListener(AreaTitleWindow.MAINTAIN_DELETE,OnDelete);
			areaTitleWindow.wheelmanagebn.addEventListener(FlexEvent.BUTTON_DOWN,OnWheelManage);
		}
		
		protected function get areaTitleWindow():AreaTitleWindow
		{
			return viewComponent as AreaTitleWindow;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_ADD_AREA_WINDOWS,
				ApplicationFacade.NOTIFY_AREAWHEEL_COMPLETE,
				ApplicationFacade.NOTIFY_INIT_WHEEL_COMPLETE,
				ApplicationFacade.NOTIFY_WHEELHISTORY_COMPLETE,
				ApplicationFacade.NOTIFY_ADD_MAINTAIN,
				ApplicationFacade.NOTIFY_DELETE_MAINTAIN,
				ApplicationFacade.NOTIFY_WHEELLIST_COMPLETE,
				ApplicationFacade.NOTIFY_WHEEL_REFRESH
			];
		}
		
		
		private var aw:AreaWheelVO = new AreaWheelVO();
		private var arr2:ArrayCollection = new ArrayCollection();
		private var arr3:ArrayCollection = new ArrayCollection();
		private var wheelArr:ArrayCollection = new ArrayCollection();
		private var w:WheelVO;
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_ADD_AREA_WINDOWS:
					areaTitleWindow.colMaintain = new ArrayCollection();
					if(notification.getBody() != null)
						aw = notification.getBody() as AreaWheelVO;	
					if(areaTitleWindow.datagrid.dataProvider != null)
						areaTitleWindow.datagrid.dataProvider.removeAll();
					areaTitleWindow._id = "";
					areaTitleWindow.title =  aw.StandId.toString()+"号支架";
					areaTitleWindow.addbn.enabled = false;
					/*areaTitleWindow.editbn.enabled = false;
					areaTitleWindow.deletebn.enabled = false;
					if(areaTitleWindow.datagroup.dataProvider != null)
						areaTitleWindow.datagroup.dataProvider.removeAll();*/
					var wmarr:ArrayCollection = new ArrayCollection;
					for each(var wm:WheelManageVO in arr3)
					{
						if(wm.LineAreaId == aw.AreaId)
							wmarr.addItem(wm);
					}
					for each(var wm2:WheelManageVO in wmarr)
					{
						wm2.wheelHis.WheelDate = null;
						for each(var w:WheelVO in wheelArr)
						{
							if(wm2.WheelId == w.WheelId && w.MaintainType == 55)
							{
								wm2.wheelHis.WheelDate = w.MaintainTime;
								wm2.wheelHis.Wheelhour = w.HourDiff;
							}
							if(wm2.WheelId == w.WheelId && w.MaintainType == 60)
							{
								wm2.wheelHis.StandDate = w.MaintainTime;
								wm2.wheelHis.Standhour = w.HourDiff;
							}
						}
					}
						
					areaTitleWindow.datagroup.dataProvider = wmarr;
					/*var wheelManageProxy:WheelManageProxy = facade.retrieveProxy(WheelManageProxy.NAME) as WheelManageProxy;
					wheelManageProxy.InitWheel(aw.AreaId);*/
					var maintainTypeProxy:MaintainTypeProxy = facade.retrieveProxy(MaintainTypeProxy.NAME) as MaintainTypeProxy;
					maintainTypeProxy.InitMaintainType();
					areaTitleWindow.datagroup.addEventListener(MouseEvent.CLICK,onclick);
					areaTitleWindow.addEventListener(CloseEvent.CLOSE,OnClose);
					var chooseid:String = FlexGlobals.topLevelApplication.WheelId;
					if(chooseid != "")
					{
						areaTitleWindow.imgclick(chooseid);
						areaTitleWindow.addbn.enabled = true;
						/*areaTitleWindow.editbn.enabled = true;
						areaTitleWindow.deletebn.enabled = true;*/
						var wheelHistoryProxy2:WheelHistoryProxy = facade.retrieveProxy(WheelHistoryProxy.NAME) as WheelHistoryProxy;
						wheelHistoryProxy2.InitWheelHistory(chooseid);
						FlexGlobals.topLevelApplication.WheelId = "";
					}
					break;
				case ApplicationFacade.NOTIFY_WHEELLIST_COMPLETE:
					arr3.removeAll();
					arr3 = notification.getBody() as ArrayCollection;
					sendNotification(ApplicationFacade.NOTIFY_ADD_AREA_WINDOWS);
					//areaTitleWindow.datagroup.dataProvider = arr3;
					break;
				case ApplicationFacade.NOTIFY_INIT_WHEEL_COMPLETE:			
					wheelArr = notification.getBody() as ArrayCollection;
					break;
				case ApplicationFacade.NOTIFY_AREAWHEEL_COMPLETE:
					var arr:ArrayCollection = notification.getBody() as ArrayCollection;
					areaTitleWindow.datagroup.dataProvider = arr;
					areaTitleWindow.datagroup.addEventListener(MouseEvent.CLICK,onclick);
					break;
				case ApplicationFacade.NOTIFY_WHEELHISTORY_COMPLETE:
					arr2 = notification.getBody() as ArrayCollection;
					areaTitleWindow.colMaintain = arr2;
					areaTitleWindow.datagrid.dataProvider = arr2;
					break;
				case ApplicationFacade.NOTIFY_ADD_MAINTAIN:
					id = areaTitleWindow._id;
					var wheelHistoryProxy:WheelHistoryProxy = facade.retrieveProxy(WheelHistoryProxy.NAME) as WheelHistoryProxy;
					wheelHistoryProxy.InitWheelHistory(id);
					break;
				case ApplicationFacade.NOTIFY_DELETE_MAINTAIN:
					/*id = areaTitleWindow._id;
					wheelHistoryProxy = facade.retrieveProxy(WheelHistoryProxy.NAME) as WheelHistoryProxy;
					wheelHistoryProxy.InitWheelHistory(id);*/
					FlexGlobals.topLevelApplication.WheelId = areaTitleWindow._id;
					sendNotification(ApplicationFacade.NOTIFY_INIT_STATION_CHANGE);
					break;
				case ApplicationFacade.NOTIFY_WHEEL_REFRESH:
					break;
			}
		}
		
		private var id:String = "";
		
		private function onclick(event:MouseEvent):void
		{
			/*if(id != new int(areaTitleWindow._id))
			{*/
				id = areaTitleWindow._id;
				if(id != "")
				{
					areaTitleWindow.addbn.enabled = true;
					/*areaTitleWindow.editbn.enabled = true;
					areaTitleWindow.deletebn.enabled = true;*/
					
					
					var wheelHistoryProxy:WheelHistoryProxy = facade.retrieveProxy(WheelHistoryProxy.NAME) as WheelHistoryProxy;
					wheelHistoryProxy.InitWheelHistory(id);
				}
			/*}*/
		}
		
		private var datenow:Date = new Date();
		private function OnAdd(event:FlexEvent):void
		{
			var titleWindowBaseInfo:TitleWindowBaseInfo = facade.retrieveMediator(TitleWindowBaseInfoMediator.NAME).getViewComponent() as TitleWindowBaseInfo;
			
			var wh:WheelHistoryVO = new WheelHistoryVO({});
			wh.MaintainInfo = "";
			wh.MaintainTips = "";
			wh.MaintainUser = FlexGlobals.topLevelApplication.UserName;
			wh.Memo = "";
			titleWindowBaseInfo._id = areaTitleWindow._id;
			titleWindowBaseInfo._ropeway = FlexGlobals.topLevelApplication.Station;
			//titleWindowBaseInfo.textMinS.text = "";
			titleWindowBaseInfo.baseInfo = wh;
			PopUpManager.addPopUp(titleWindowBaseInfo, areaTitleWindow, true);
			titleWindowBaseInfo.move(areaTitleWindow.width/2-titleWindowBaseInfo.width/2+areaTitleWindow.x,areaTitleWindow.height/2-titleWindowBaseInfo.height/2+areaTitleWindow.y);
			if(titleWindowBaseInfo.dateDayS != null)
				titleWindowBaseInfo.dateDayS.selectedDate = datenow;
			if(titleWindowBaseInfo.textHourS != null)
				titleWindowBaseInfo.textHourS.value = datenow.hours;
			if(titleWindowBaseInfo.cbisChange != null)
				titleWindowBaseInfo.cbisChange.selected = false;
			titleWindowBaseInfo.listMaintainType.dataProvider = MaintainTypeProxy.typeList;
			titleWindowBaseInfo.listMaintainType.selectedIndex = 0;
			titleWindowBaseInfo.type = "ADD";
		}
		private function OnEdit(event:Event):void
		{
			if(areaTitleWindow.datagrid.selectedItem != null)
			{
				var titleWindowBaseInfo:TitleWindowBaseInfo = facade.retrieveMediator(TitleWindowBaseInfoMediator.NAME).getViewComponent() as TitleWindowBaseInfo;
				PopUpManager.addPopUp(titleWindowBaseInfo, areaTitleWindow, true);
				titleWindowBaseInfo.move(areaTitleWindow.width/2-titleWindowBaseInfo.width/2+areaTitleWindow.x,areaTitleWindow.height/2-titleWindowBaseInfo.height/2+areaTitleWindow.y);
				titleWindowBaseInfo.listMaintainType.dataProvider = MaintainTypeProxy.typeList;
				titleWindowBaseInfo._id = areaTitleWindow._id;
				titleWindowBaseInfo._ropeway = FlexGlobals.topLevelApplication.Station;
				titleWindowBaseInfo.baseInfo = arr2[areaTitleWindow.datagrid.selectedIndex];
				if(titleWindowBaseInfo.baseInfo.MaintainTips == "1")
					titleWindowBaseInfo.cbisChange.selected = true;
				else
					titleWindowBaseInfo.cbisChange.selected = false;
				titleWindowBaseInfo.textHourS.value = titleWindowBaseInfo.baseInfo.MaintainTime.hours;
				//titleWindowBaseInfo.textMinS.text = titleWindowBaseInfo.baseInfo.MaintainTime.minutes.toString();
				titleWindowBaseInfo.dateDayS.selectedDate = titleWindowBaseInfo.baseInfo.MaintainTime;
				titleWindowBaseInfo.type = "EDIT";
			}
			else
			{
				Alert.show("请选择一条维护记录！","提示");
			}
		}
		private function OnDelete(event:Event):void
		{
			if(areaTitleWindow.datagrid.selectedItem != null)
			{
				Alert.show("是否删除信息？","",(Alert.YES | Alert.NO),null,onBaseInfoDelConfirm);
				function onBaseInfoDelConfirm(event:CloseEvent):void
				{
					if(event.detail == Alert.YES)
					{
						var id:int = arr2[areaTitleWindow.datagrid.selectedIndex].Id;
						var wheelHistoryProxy:WheelHistoryProxy = facade.retrieveProxy(WheelHistoryProxy.NAME) as WheelHistoryProxy;
						wheelHistoryProxy.DeleteWheelHistory(id);
					}
				}
			}
			else
			{
				Alert.show("请选择一条维护记录！","提示");
			}
		}
		
		private function OnWheelManage(event:FlexEvent):void
		{
			var titleWindowManage:TitleWindowManage = facade.retrieveMediator(TitleWindowManageMediator.NAME).getViewComponent() as TitleWindowManage;
			PopUpManager.addPopUp(titleWindowManage, areaTitleWindow, true);
			titleWindowManage.move(areaTitleWindow.width/2-titleWindowManage.width/2+areaTitleWindow.x,areaTitleWindow.height/2-titleWindowManage.height/2+areaTitleWindow.y);
			titleWindowManage.listRopeway.text = FlexGlobals.topLevelApplication.Station;
			if(titleWindowManage.t_wheelId != null)
				titleWindowManage.t_wheelId.text = "";
			titleWindowManage.baseInfo = aw;
			var wheelManageProxy:WheelManageProxy = facade.retrieveProxy(WheelManageProxy.NAME) as WheelManageProxy;
			wheelManageProxy.InitWheelManage(aw.AreaId);
		}
		
		private function OnClose(event:CloseEvent):void
		{
			//sendNotification(ApplicationFacade.NOTIFY_INIT_STATION_CHANGE);
		}
	}
}