package app.view
{
	import app.AppEvent;
	import app.ApplicationFacade;
	import app.model.StandBaseinfoProxy;
	import app.model.StandMaintainProxy;
	import app.model.vo.AttachImageVO;
	import app.model.vo.AttachVO;
	import app.model.vo.ConfigVO;
	import app.model.vo.StandBaseinfoVO;
	import app.model.vo.StandMaintainVO;
	import app.view.components.TitleWindowStand;
	import app.view.components.TitleWindowStandMaintain;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.events.MoveEvent;
	import mx.formatters.DateFormatter;
	import mx.managers.PopUpManager;
	import mx.utils.*;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TitleWindowStandMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TitleWindowStandMediator";
		public function TitleWindowStandMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			titleWindowStand.addEventListener(TitleWindowStand.STANDINFO_SAVE,Onsave);
			titleWindowStand.addEventListener(TitleWindowStand.TAB_CHANGE,Onchange);
			titleWindowStand.addEventListener(TitleWindowStand.MAINTAIN_ADD,Onadd);
			titleWindowStand.addEventListener(TitleWindowStand.MAINTAIN_EDIT,Onedit);
			titleWindowStand.addEventListener(TitleWindowStand.MAINTAIN_DELETE,Ondelete);
			titleWindowStand.addEventListener(TitleWindowStand.MAINTAIN_SEARCH,onSearch);
			titleWindowStand.addEventListener(TitleWindowStand.PIC_UPLOAD,onUpload);
			titleWindowStand.addEventListener(TitleWindowStand.IFRAME_FOCUSOUT,onFocusout);
			
			titleWindowStand.addEventListener(AppEvent.UPLOADATTACH,onUploadAttach);
			titleWindowStand.addEventListener(AppEvent.DELETEATTACH,onDeleteAttach);
			titleWindowStand.addEventListener(AppEvent.NAVIATTACH,onNaviImage);
			titleWindowStand.addEventListener(MoveEvent.MOVE,onMove);
		}
		
		protected function get titleWindowStand():TitleWindowStand
		{
			return viewComponent as TitleWindowStand;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_ADD_STAND_WINDOWS,
				ApplicationFacade.NOTIFY_INIT_STANDINFO,
				ApplicationFacade.NOTIFY_INIT_STANDMAINTAIN
				
			];
		}
		
		private var standinfo:StandBaseinfoVO;
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_ADD_STAND_WINDOWS:	
					titleWindowStand.tn.selectedChild = titleWindowStand.nc1;
					var standid:int = notification.getBody() as int;
					var ropeway:String = FlexGlobals.topLevelApplication.Station;
					var config:ConfigVO = FlexGlobals.topLevelApplication.Config;
					var stationid:int;
					for(var i:int = 0;i < config.stations.length;i++)
					{
						if(ropeway == config.stations[i])
							stationid = config.stationsid[i];
					}
					IFDEF::Release
					{
						titleWindowStand.iframe.source="FlexEdit.aspx?ropeway="+stationid+"&bracket="+standid;
					}
					//titleWindowStand.iframe.source="http://www.baidu.com";
					titleWindowStand.iframe.setFocus();
					titleWindowStand._ropeway = ropeway;
					titleWindowStand._standId = standid;
					/*var standBaseinfoProxy:StandBaseinfoProxy = facade.retrieveProxy(StandBaseinfoProxy.NAME) as StandBaseinfoProxy;
					standBaseinfoProxy.InitStandInfo(standid);*/
					sendNotification(ApplicationFacade.NOTIFY_INIT_STANDINFO);
					break;
				case ApplicationFacade.NOTIFY_INIT_STANDINFO:
					var atach:AttachImageVO = null;
					var art:ArrayCollection = new ArrayCollection();	
					art.addItem(atach);
					//titleWindowStand.attachList.dataProvider = art;
					standinfo = notification.getBody() as StandBaseinfoVO;
					IFDEF::Release
					{
						titleWindowStand.iframe.callIFrameFunction("eneditfunction");
					}
					//titleWindowStand.standinforich.htmlText = standinfo.BracketInfo;
					break;
				case ApplicationFacade.NOTIFY_INIT_STANDMAINTAIN:			
					var standMaintainArr:ArrayCollection = notification.getBody() as ArrayCollection;
					titleWindowStand.datagrid.dataProvider = standMaintainArr;
					break;
				
			}
		}
		
		private function Onsave(event:Event):void
		{
			//titleWindowStand.standinforich.htmlText;
			/*titleWindowStand.iframe.source="http://192.168.1.212:40000/MaintenanceEntry/WheelFlex/FlexEdit.aspx?ropeway=2&bracket=5";*/
			titleWindowStand.iframe.callIFrameFunction("savefunction");
		}
		
		private function settextarea(datastr:String):void
		{
			standinfo.BracketInfo = datastr;
			standinfo.LastEditUser = FlexGlobals.topLevelApplication.UserName;
			var dateFormatter:DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
			standinfo.LastEditTie = dateFormatter.format(new Date());
			var standBaseinfoProxy:StandBaseinfoProxy = facade.retrieveProxy(StandBaseinfoProxy.NAME) as StandBaseinfoProxy;
			standBaseinfoProxy.UpdataStandInfo(standinfo);
		}
		
		private function Onchange(event:Event):void
		{
			var standMaintainProxy:StandMaintainProxy = facade.retrieveProxy(StandMaintainProxy.NAME) as StandMaintainProxy;
			standMaintainProxy.InitStandMaintain(titleWindowStand._standId);
		}
		private function Onadd(event:Event):void
		{
			var datenow:Date = new Date();
			var titleWindowStandMaintain:TitleWindowStandMaintain = facade.retrieveMediator(TitleWindowStandMaintainMediator.NAME).getViewComponent() as TitleWindowStandMaintain;
			titleWindowStandMaintain._id = titleWindowStand._standId;
			titleWindowStandMaintain._ropeway = FlexGlobals.topLevelApplication.Station;
			PopUpManager.addPopUp(titleWindowStandMaintain, titleWindowStand, true);
			titleWindowStandMaintain.move(titleWindowStand.width/2-titleWindowStandMaintain.width/2+titleWindowStand.x,titleWindowStand.height/2-titleWindowStandMaintain.height/2+titleWindowStand.y);
			if(titleWindowStandMaintain.dateDayS != null)
				titleWindowStandMaintain.dateDayS.selectedDate = datenow;
			if(titleWindowStandMaintain.textHourS != null)
				titleWindowStandMaintain.textHourS.value = datenow.hours;
			//titleWindowStandMaintain.maintainInfo.text = "";
			titleWindowStandMaintain.maintainUser.text = FlexGlobals.topLevelApplication.UserName;
			titleWindowStandMaintain.datagrid.editable = true;
			titleWindowStandMaintain.maintainUser.enabled = true;
			titleWindowStandMaintain.dateDayS.enabled = true;
			titleWindowStandMaintain.textHourS.enabled = true;
			titleWindowStandMaintain.submit.visible = true;
			titleWindowStandMaintain.type = "ADD";
			sendNotification(ApplicationFacade.NOTIFY_STANDMAINTAIN_WINDOWS,titleWindowStandMaintain._id);
		}
		private function Onedit(event:Event):void
		{
			if(titleWindowStand.datagrid.selectedItem != null)
			{
				var titleWindowStandMaintain:TitleWindowStandMaintain = facade.retrieveMediator(TitleWindowStandMaintainMediator.NAME).getViewComponent() as TitleWindowStandMaintain;
				PopUpManager.addPopUp(titleWindowStandMaintain, titleWindowStand, true);
				titleWindowStandMaintain.move(titleWindowStand.width/2-titleWindowStandMaintain.width/2+titleWindowStand.x,titleWindowStand.height/2-titleWindowStandMaintain.height/2+titleWindowStand.y);
				titleWindowStandMaintain._id = titleWindowStand._standId;
				titleWindowStandMaintain._ropeway = titleWindowStand._ropeway;
				titleWindowStandMaintain.dateDayS.selectedDate = titleWindowStand.datagrid.selectedItem.MDate;
				titleWindowStandMaintain.textHourS.value = titleWindowStand.datagrid.selectedItem.MDate.hours;
				//titleWindowStandMaintain.maintainInfo.text = titleWindowStand.datagrid.selectedItem.MaintainInfo;
				titleWindowStandMaintain.maintainUser.text = titleWindowStand.datagrid.selectedItem.InputUserName;
				titleWindowStandMaintain.Id = titleWindowStand.datagrid.selectedItem.Id;
				titleWindowStandMaintain.maintainUser.enabled = false;
				titleWindowStandMaintain.dateDayS.enabled = false;
				titleWindowStandMaintain.textHourS.enabled = false;
				titleWindowStandMaintain.datagrid.editable = false;
				titleWindowStandMaintain.submit.visible = false;
				titleWindowStandMaintain.type = "GET";
				var standMaintainProxy:StandMaintainProxy = facade.retrieveProxy(StandMaintainProxy.NAME) as StandMaintainProxy;
				standMaintainProxy.InitStandMaintainData(titleWindowStand.datagrid.selectedItem.Id);
			}
			else
			{
				Alert.show("请选择一条维护记录！","提示");
			}
		}
		private function Onedit2(event:Event):void
		{
			if(titleWindowStand.datagrid.selectedItem != null)
			{
				var titleWindowStandMaintain:TitleWindowStandMaintain = facade.retrieveMediator(TitleWindowStandMaintainMediator.NAME).getViewComponent() as TitleWindowStandMaintain;
				PopUpManager.addPopUp(titleWindowStandMaintain, titleWindowStand, true);
				titleWindowStandMaintain.move(titleWindowStand.width/2-titleWindowStandMaintain.width/2+titleWindowStand.x,titleWindowStand.height/2-titleWindowStandMaintain.height/2+titleWindowStand.y);
				titleWindowStandMaintain._id = titleWindowStand._standId;
				titleWindowStandMaintain._ropeway = titleWindowStand._ropeway;
				titleWindowStandMaintain.dateDayS.selectedDate = titleWindowStand.datagrid.selectedItem.MainTainDate;
				titleWindowStandMaintain.textHourS.value = titleWindowStand.datagrid.selectedItem.MainTainDate.hours;
				//titleWindowStandMaintain.maintainInfo.text = titleWindowStand.datagrid.selectedItem.MaintainInfo;
				titleWindowStandMaintain.maintainUser.text = titleWindowStand.datagrid.selectedItem.MaintainMan;
				titleWindowStandMaintain.Id = titleWindowStand.datagrid.selectedItem.Id;
				titleWindowStandMaintain.type = "EDIT";
			}
			else
			{
				Alert.show("请选择一条维护记录！","提示");
			}
		}
		private function Ondelete(event:Event):void
		{
			if(titleWindowStand.datagrid.selectedItem != null)
			{
				Alert.show("是否删除信息？","",(Alert.YES | Alert.NO),null,onBaseInfoDelConfirm);
				function onBaseInfoDelConfirm(event:CloseEvent):void
				{
					if(event.detail == Alert.YES)
					{
						var standMaintainProxy:StandMaintainProxy = facade.retrieveProxy(StandMaintainProxy.NAME) as StandMaintainProxy;
						standMaintainProxy.DeleteStandMaintain(titleWindowStand.datagrid.selectedItem);
					}
				}
			}
			else
			{
				Alert.show("请选择一条维护记录！","提示");
			}
		}
		
		private function onSearch(evetn:Event):void
		{
			var standMaintainProxy:StandMaintainProxy = facade.retrieveProxy(StandMaintainProxy.NAME) as StandMaintainProxy;
			var dateFormatter:DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD";
			var where:String = "  MainTainDate> '" + dateFormatter.format(titleWindowStand.dateDayF.selectedDate) + " 00:00:00' and  MainTainDate< '" + dateFormatter.format(titleWindowStand.dateDayT.selectedDate) + " 23:59:59'";
			standMaintainProxy.SearchStandMaintain(standinfo.BracketId,where);
		}
		
		private var fileReference:FileReference = new FileReference();
		private function onUpload(evetn:Event):void
		{
			fileReference=new FileReference();
			fileReference.addEventListener(Event.SELECT , selectHandler);
			fileReference.addEventListener(Event.COMPLETE , completeHandler);
			fileReference.browse([new FileFilter("*.jpg","*.jpg")]);
		}
		
		private function selectHandler(event:Event):void{
			if(fileReference.size>0)
				fileReference.load();
		}
		
		private function completeHandler(event:Event):void
		{
			if (fileReference.size > 0) {
				var request:URLRequest = new URLRequest("http://218.242.45.170/pata/FileService.aspx");
				fileReference.upload(request);
			} 
		}
		
		private function onUploadAttach(event:AppEvent):void
		{
			//attachProxy.uploadConsultImage();
		}
		
		private function onDeleteAttach(event:AppEvent):void
		{
			//attachProxy.deleteConsultImage(event.data);
		}
		
		private function onNaviImage(event:AppEvent):void
		{			
			//var attachImage:AttachImageVO = event.data as AttachImageVO;
			
			//sendNotification(ApplicationFacade.NOTIFY_POPUP_SHOW,[facade.retrieveMediator(PopupNaviImageMediator.NAME).getViewComponent(),event.data]);
					
		}
		
		protected function onMove(event:MoveEvent):void
		{
			titleWindowStand.iframe.invalidateDisplayList();
		}
		private var timer:Timer = new Timer(100,1);
		protected function onFocusout(event:Event):void
		{
			//timer.addEventListener(TimerEvent.TIMER,onTime);
			//timer.start();
		}
		private function onTime(event:TimerEvent):void
		{
			titleWindowStand.iframe.invalidateDisplayList();
		}
	}
}