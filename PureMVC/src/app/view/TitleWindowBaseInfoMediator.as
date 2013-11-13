package app.view
{
	import app.ApplicationFacade;
	import app.model.WheelHistoryProxy;
	import app.model.vo.WheelHistoryVO;
	import app.view.components.TitleWindowBaseInfo;
	
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.formatters.DateFormatter;
	import mx.managers.PopUpManager;
	import mx.utils.*;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TitleWindowBaseInfoMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TitleWindowBaseInfoMediator";
		public function TitleWindowBaseInfoMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			titleWindowBaseInfo.addEventListener(TitleWindowBaseInfo.BASEINFO_NEW,onSubmit);
		}
		
		protected function get titleWindowBaseInfo():TitleWindowBaseInfo
		{
			return viewComponent as TitleWindowBaseInfo;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_ADD_MAINTAIN,
				ApplicationFacade.NOTIFY_DELETE_MAINTAIN,
				ApplicationFacade.NOTIFY_WHEELHISTORY_COMPLETE
			];
		}
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_ADD_MAINTAIN:
					FlexGlobals.topLevelApplication.WheelId = titleWindowBaseInfo._id;
					sendNotification(ApplicationFacade.NOTIFY_INIT_STATION_CHANGE);
					PopUpManager.removePopUp(titleWindowBaseInfo);
					break;
				case ApplicationFacade.NOTIFY_DELETE_MAINTAIN:
					break;
				case ApplicationFacade.NOTIFY_WHEELHISTORY_COMPLETE:
					break;
			}
		}
		
		private function onSubmit(event:Event):void
		{
			var o:Object = new Object();
			o.WheelId = titleWindowBaseInfo._id;
			o.MaintainInfo = titleWindowBaseInfo.maintainInfo.text;
			if(titleWindowBaseInfo.cbisChange.selected == true)
			{
				o.MaintainTips = "1";
			}
			else
			{
				o.MaintainTips = "0";
			}
			o.MaintainUser = titleWindowBaseInfo.maintainUser.text;
			o.Memo = titleWindowBaseInfo.memo.text;
			for each(var obj:Object in WheelHistoryProxy.MaintainType)
			{
				if(titleWindowBaseInfo.listMaintainType.selectedItem == obj.DicValue)
					o.MaintainType = obj.DicId;
			}
			var dateFormatter:DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
			o.MaintainTime = dateFormatter.format(titleWindowBaseInfo.dateS);
			var wheelHistoryProxy:WheelHistoryProxy = facade.retrieveProxy(WheelHistoryProxy.NAME) as WheelHistoryProxy;
			if(titleWindowBaseInfo.type == "ADD")
				wheelHistoryProxy.AddWheelHistory(o);
			else if(titleWindowBaseInfo.type == "EDIT")
			{
				o.Id = titleWindowBaseInfo.baseInfo.Id
				wheelHistoryProxy.EditWheelHistory(o);
			}
		}
	}
}