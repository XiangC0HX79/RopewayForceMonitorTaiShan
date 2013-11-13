package app.view
{
	import app.ApplicationFacade;
	import app.model.StandMaintainProxy;
	import app.model.vo.StandConfigVO;
	import app.model.vo.StandMaintainDataVO;
	import app.model.vo.StandMaintainVO;
	import app.view.components.TitleWindowStandMaintain;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.utils.*;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TitleWindowStandMaintainMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TitleWindowStandMaintainMediator";
		
		public function TitleWindowStandMaintainMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			titleWindowStandMaintain.addEventListener(TitleWindowStandMaintain.BASEINFO_NEW,OnSubmit);
		}
		
		protected function get titleWindowStandMaintain():TitleWindowStandMaintain
		{
			return viewComponent as TitleWindowStandMaintain;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_STANDMAINTAIN_WINDOWS,
				ApplicationFacade.NOTIFY_INIT_STANDCONFIG,
				ApplicationFacade.NOTIFY_ADD_MAINTAINDATA,
				
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var standMaintainProxy:StandMaintainProxy = facade.retrieveProxy(StandMaintainProxy.NAME) as StandMaintainProxy;
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_STANDMAINTAIN_WINDOWS:	
					var standid:int = notification.getBody() as int;
					standMaintainProxy.InitStandConfig(standid);
					break;
				case ApplicationFacade.NOTIFY_INIT_STANDCONFIG:	
					if(titleWindowStandMaintain.type == "ADD")
					{
						var sc:StandConfigVO = notification.getBody() as StandConfigVO;
						eleadd(sc.CheckItemNamePairs,sc.CheckItemIdPairs);
					}
					else
					{
						var arr:ArrayCollection = notification.getBody() as ArrayCollection;
						var num:int = arr.length;
						//titleWindowStandMaintain.height = 200 + num*50;
						titleWindowStandMaintain.datagrid.dataProvider = arr;
					}
					break;
				case ApplicationFacade.NOTIFY_ADD_MAINTAINDATA:	
					var id:int = notification.getBody() as int;
					for each(var ob:Object in titleWindowStandMaintain.datagrid.dataProvider)
					{
						if(ob.CheckData != "")
						{
							standMaintainProxy.AddStandMaintainData(id,ob);
						}
					}
					//standMaintainProxy.AddStandMaintainData(id,arr);
					break;
				
			}
		}
		private function eleadd(allname:String,allnum:String):void
		{
			var MainDataArr:ArrayCollection = new ArrayCollection();
			var num:int = allname.split(",").length;
			//titleWindowStandMaintain.height = 200 + num*50;
			for(var i:int = 0;i<allname.split(",").length;i++)
			{
				var o:Object = new Object();
				o.CheckItemName = allname.split(",")[i];
				o.CheckItemId = allnum.split(",")[i];
				o.CheckData = "";
				MainDataArr.addItem(o);
			}
			titleWindowStandMaintain.datagrid.dataProvider = MainDataArr;
			titleWindowStandMaintain.datagrid.editedItemPosition = {columnIndex:1, rowIndex:0};
		}
		
		private function OnSubmit(event:Event):void
		{
			var i:int = 0;
			for each(var sco:Object in titleWindowStandMaintain.datagrid.dataProvider)
			{
				if(sco.CheckData != "")
					i++;
			}
			if(i > 0)
			{
				var s:StandMaintainVO = new StandMaintainVO({});
				var standMaintainProxy:StandMaintainProxy = facade.retrieveProxy(StandMaintainProxy.NAME) as StandMaintainProxy;
				if(titleWindowStandMaintain.type == "ADD")
				{
					s.RopeWay = titleWindowStandMaintain._ropeway;
					s.BracketId = titleWindowStandMaintain._id;
					s.InputUserName = titleWindowStandMaintain.maintainUser.text;
					s.MDate = titleWindowStandMaintain.dateS;
					standMaintainProxy.AddStandMaintain(s);
				}
				else
				{
					/*s.RopeWay = titleWindowStandMaintain._ropeway;
					s.Bracket = titleWindowStandMaintain._id;
					s.MaintainInfo = titleWindowStandMaintain.maintainInfo.text;
					s.MaintainMan = titleWindowStandMaintain.maintainUser.text;
					s.MainTainDate = titleWindowStandMaintain.dateS;
					s.Id = titleWindowStandMaintain.Id;
					standMaintainProxy.EditStandMaintain(s);*/
				}
				titleWindowStandMaintain.closewindow();
			}
			else
			{
				Alert.show("请输入维护内容！","提示");
			}
		}
	}
}