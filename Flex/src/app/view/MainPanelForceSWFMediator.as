package app.view
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import mx.controls.SWFLoader;
	import mx.events.FlexEvent;
	import mx.managers.SystemManager;
	import mx.modules.IModuleInfo;
	
	import app.view.components.MainPanelForceSWF;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainPanelForceSWFMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainPanelForceSWFMediator";
		
		public function MainPanelForceSWFMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get mainPanelForceSWF():MainPanelForceSWF
		{
			return viewComponent as MainPanelForceSWF;
		}
	}
}