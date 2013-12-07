package app.view
{	
	import app.ApplicationFacade;
	import app.model.StandProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.WarnTypeVO;
	
	import flash.events.Event;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.IVisualElement;
	import mx.events.ResizeEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
		
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		public function ApplicationMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			application.DepIds = application.parameters.DepIds;
			IFDEF::Debug
			{
				application.DepIds = "2";
			}
			
			application.warngroup.addElement(facade.retrieveMediator(PanelRopewayAlarmMediator.NAME).getViewComponent() as IVisualElement);
		}
		
		protected function get application():PurMVC
		{
			return viewComponent as PurMVC;
		}
		
		private function changeContent(n:String):void
		{
			application.main.removeAllElements();
			
			var mediator:IMediator = facade.retrieveMediator(n);
			application.main.addElement(mediator.getViewComponent() as IVisualElement);			
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,
				
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				
				ApplicationFacade.NOTIFY_MENU_MAINCONENT,
				
				ApplicationFacade.NOTIFY_MENU_MANAGE,
				
				ApplicationFacade.NOTIFY_WARNING_GET
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{			
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					var config:ConfigVO = notification.getBody() as ConfigVO;
					//application.UserName = application.parameters.name;
					application.Config = config;
					/*var wt:String = application.parameters.warntype;
					for each(var str:String in wt.split("/"))
					{
						var warntype:WarnTypeVO = new WarnTypeVO();
						var array:Array = str.split(",");
						warntype.type = array[0];
						warntype.yhour = array[1];
						warntype.rhour = array[2];
						application.WarnArr.addItem(warntype);
					}*/
					var depId:String = application.parameters.id;
					IFDEF::Debug
					{
						depId = "4";
					}
					
					for(var i:int = 0;i<config.stationsid.length;i++)
					{						
						if(config.stationsid[i] == depId)
							application.Station = config.stations[i];
					}
					break;
				
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
					changeContent(MainConentMediator.NAME);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_MAINCONENT:
					changeContent(MainConentMediator.NAME);
					break;
				
				case ApplicationFacade.NOTIFY_MENU_MANAGE:
					changeContent(ContentManageMediator.NAME);
					break;
				
				case ApplicationFacade.NOTIFY_WARNING_GET:
					
					break;
			}
		}		
	}
}