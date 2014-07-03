package app.controller
{
	import flash.errors.IllegalOperationError;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
		
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.AsyncCommand;
	
	public class BaseActionPanelChangeCommand extends AsyncCommand
	{
		protected function get action():String
		{
			throw(new IllegalOperationError("调用抽象方法"));			
		}
		
		protected function get mediatorName():String
		{			
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		override public function execute(notification:INotification):void
		{
			var ui:UIComponent = facade.retrieveMediator(mediatorName).getViewComponent() as UIComponent;
			ui.addEventListener(FlexEvent.ADD,onUiAdd);
			sendNotification(action,ui);
		}
		
		private function onUiAdd(event:FlexEvent):void
		{
			(event.currentTarget as UIComponent).removeEventListener(FlexEvent.ADD,onUiAdd);
			
			commandComplete();
		}
	}
}