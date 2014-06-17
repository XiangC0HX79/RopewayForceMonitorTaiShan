package app.controller
{
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	
	import spark.components.Application;
	
	import app.ApplicationFacade;
	import app.model.CarriageProxy;
	import app.model.ConfigProxy;
	import app.model.EngineTempProxy;
	import app.model.ForceRealtimeDetectionAlarmProxy;
	import app.model.InchProxy;
	import app.model.dict.RopewayDict;
	import app.model.dict.RopewayStationDict;
	import app.model.vo.EngineVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class NotifyInitAppCommand extends SimpleCommand implements ICommand
	{
		private static const INITCOUNT:Number = 1;
		
		private static var _init:Number;
				
		override public function execute(note:INotification):void
		{
			sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_SHOW,"初始化数据...");
			
			_init = 0;
			
			var application:Application = note.getBody() as Application;
						
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;			
			configProxy.InitConfig(onLocaleConfigResult);
		}
		
		private function appInit():void
		{
			if(++_init == INITCOUNT)
			{											
				sendNotification(ApplicationFacade.NOTIFY_INIT_APP_COMPLETE);
				
				sendNotification(ApplicationFacade.NOTIFY_MAIN_LOADING_HIDE);
			}
		}
		
		private function onFault(error:FaultEvent, token:Object = null):void
		{
			sendNotification(ApplicationFacade.NOTIFY_ALERT_ERROR,error.fault.faultDetail);
		}
		
		private function onLocaleConfigResult(event:Event):void
		{								
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			sendNotification(ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE,configProxy.config);
			
			//初始化动力室
			//var engineTempProxy:EngineTempProxy = facade.retrieveProxy(EngineTempProxy.NAME) as EngineTempProxy;
			//engineTempProxy.Init();
			
			//初始化张紧小尺
			//var inchProxy:InchProxy = facade.retrieveProxy(InchProxy.NAME) as InchProxy;
			//inchProxy.Init();
			
			//初始化吊箱
			//var carriageProxy:CarriageProxy = facade.retrieveProxy(CarriageProxy.NAME) as CarriageProxy;
			//carriageProxy.Init().addResponder(new AsyncResponder(onCarriageInit,onFault));
			
			//初始化报警列表
			//var ropewayAlarmDealProxy:ForceRealtimeDetectionAlarmProxy = facade.retrieveProxy(ForceRealtimeDetectionAlarmProxy.NAME) as ForceRealtimeDetectionAlarmProxy;
			//ropewayAlarmDealProxy.Init().addResponder(new AsyncResponder(onForceAlarmInit,onFault));
						
			appInit();
		}
		
		private function onCarriageInit(result:Object, token:Object = null):void
		{						
			var carriageProxy:CarriageProxy = facade.retrieveProxy(CarriageProxy.NAME) as CarriageProxy;
			carriageProxy.InitStationForce().addResponder(new AsyncResponder(onStationInit,onFault));			
		}
		
		private function onStationInit(result:Object, token:Object = null):void
		{		
			appInit();
		}
		
		private function onForceAlarmInit(result:Object, token:Object = null):void
		{						
			appInit();	
		}
	}
}