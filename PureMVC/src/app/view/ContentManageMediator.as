package app.view
{
	import app.ApplicationFacade;
	import app.view.components.ContentManage;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.RadioButton;
	import spark.components.RadioButtonGroup;
	import spark.events.GridSelectionEvent;
	
	public class ContentManageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentManageMediator";
		public function ContentManageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			contentManage.addEventListener(FlexEvent.CREATION_COMPLETE,onCreation);
		}
		
		protected function get contentManage():ContentManage
		{
			return viewComponent as ContentManage;
		}
		
		private function onCreation(event:FlexEvent):void
		{
			contentManage.addbn.addEventListener(FlexEvent.BUTTON_DOWN,onadd);
			//contentManage.editbn.addEventListener(FlexEvent.BUTTON_DOWN,onedit);
			contentManage.deletebn.addEventListener(FlexEvent.BUTTON_DOWN,ondelete);
			contentManage.datagrid.addEventListener(GridSelectionEvent.SELECTION_CHANGE,onselect);
			var arr:ArrayCollection = new ArrayCollection();
		}
		
		private function onselect(event:GridSelectionEvent):void
		{
			if(contentManage.datagrid.selectedItem != null)
			{
				
			}
		}
		
		private function onadd(event:FlexEvent):void
		{
			
		}
		
		private function onedit(event:FlexEvent):void
		{
		}
		
		private function ondelete(event:FlexEvent):void
		{
		}
		
		private function onupdate():void
		{
			
		}
	}
}