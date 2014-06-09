package app.view
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.controls.Alert;
	import mx.managers.PopUpManager;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import app.ApplicationFacade;
	import app.model.HolderMgProxy;
	import app.model.vo.HolderMgVO;
	import app.view.components.TitleWindowProject;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class TitleWindowProjectMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "TitleWindowProjectMediator";
		
		private var holderMgProxy:HolderMgProxy;
		
		public function TitleWindowProjectMediator()
		{
			super(NAME, new TitleWindowProject);
			
			titleWindowProject.addEventListener(TitleWindowProject.SAVE,onSave);
			
			holderMgProxy = facade.retrieveProxy(HolderMgProxy.NAME) as HolderMgProxy;
		}
		
		public function get titleWindowProject():TitleWindowProject
		{
			return viewComponent as TitleWindowProject;
		}
				
		private function onSave(event:Event):void
		{
			var token:AsyncToken;
			
			if(titleWindowProject.holderMgVO.Id)
			{
				token = holderMgProxy.Edit(titleWindowProject.holderMgVO);			
				token.addResponder(new AsyncResponder(onEdit,function(error:FaultEvent,t:Object):void{trace(error);}));
			}
			else
			{
				token = holderMgProxy.Add(titleWindowProject.holderMgVO);			
				token.addResponder(new AsyncResponder(onAdd,function(error:FaultEvent,t:Object):void{trace(error);}));	
			}
		}
		
		private function onEdit(event:ResultEvent,token:AsyncToken = null):void
		{
			if(event.result)
			{
				Alert.show("编辑维护计划成功！");
				PopUpManager.removePopUp(titleWindowProject);
			}
			else
			{
				Alert.show("编辑维护计划失败！");				
			}
		}
		
		private function onAdd(event:ResultEvent,token:AsyncToken = null):void
		{
			Alert.show("新增维护计划成功！");
			PopUpManager.removePopUp(titleWindowProject);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_TITLEWINDOW_PROJECT_SHOW
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_TITLEWINDOW_PROJECT_SHOW:
					var parent:DisplayObject = notification.getBody()[0] as DisplayObject;						
					var holderMgVO:HolderMgVO = notification.getBody()[1] as HolderMgVO;		
					
					PopUpManager.addPopUp(titleWindowProject,parent,true);
					PopUpManager.centerPopUp(titleWindowProject);
					
					if(holderMgVO.Id)
					{
						titleWindowProject.title = "编辑维护计划";
					}
					else
					{
						titleWindowProject.title = "新增维护计划";
					}
					
					titleWindowProject.holderMgVO = holderMgVO;
					break;
			}
		}
	}
}