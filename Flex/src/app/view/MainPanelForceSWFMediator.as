package app.view
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.System;
	
	import mx.controls.SWFLoader;
	import mx.events.FlexEvent;
	import mx.managers.SystemManager;
	import mx.modules.IModuleInfo;
	
	import app.ApplicationFacade;
	import app.common.PipeAwareModule;
	import app.view.components.MainPanelForceSWF;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeAware;
	
	public class MainPanelForceSWFMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainPanelForceSWFMediator";
				
		public function MainPanelForceSWFMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
						
			mainPanelForceSWF.force.addEventListener(Event.COMPLETE,onSWFLoader);
		}
				
		protected function get mainPanelForceSWF():MainPanelForceSWF
		{
			return viewComponent as MainPanelForceSWF;
		}
		
		private function onSWFLoader(event:Event):void
		{			
			event.target.removeEventListener(Event.COMPLETE,onSWFLoader);
			
			var loadedSM:SystemManager=SystemManager(event.target.content);
			loadedSM.addEventListener(FlexEvent.APPLICATION_COMPLETE,onAppInit);
		}
		
		private function onAppInit(event:Event):void
		{
			event.target.removeEventListener(FlexEvent.APPLICATION_COMPLETE,onAppInit);
			
			var moduleForce:IPipeAware = (event.target as SystemManager).application as IPipeAware;
			sendNotification(ApplicationFacade.NOTIFY_MAIN_FORCE_INIT,moduleForce);			
		}
	}
}