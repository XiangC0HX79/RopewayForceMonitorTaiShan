package app.controller
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	
	import spark.components.Application;
	
	import app.ApplicationFacade;
	import app.model.CarriageProxy;
	import app.model.ConfigProxy;
	import app.model.EngineTempProxy;
	import app.model.dict.RopewayDict;
	import app.model.vo.EngineVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class AppInitCommand extends SimpleCommand implements ICommand
	{
		private static const INITCOUNT:Number = 2;
		
		private static var _init:Number = 0;
		
		private static var _ropewayId:int = 0;
		
		override public function execute(note:INotification):void
		{
			var application:Application = note.getBody() as Application;
			
			_ropewayId = int(application.parameters.station);
			
			var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
			
			configProxy.InitConfig(application.parameters.station,onLocaleConfigResult);
		}
		
		private function appInit():void
		{
			if(++_init == INITCOUNT)
			{							
				var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;	
				configProxy.config.ropeway = RopewayDict.dict[_ropewayId]?RopewayDict.dict[_ropewayId]:RopewayDict.list[0];
				
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
			//初始化索道
			RopewayDict.dict[RopewayDict.ZHONG_TIAN_MEN.id] = RopewayDict.ZHONG_TIAN_MEN;
			RopewayDict.dict[RopewayDict.TAO_HUA_YUAN.id] = RopewayDict.TAO_HUA_YUAN;
						
			//初始化动力室
			var engineTempProxy:EngineTempProxy = facade.retrieveProxy(EngineTempProxy.NAME) as EngineTempProxy;
			for each(var rw:RopewayDict in RopewayDict.dict)
			{
				var e:EngineVO = new EngineVO;
				e.ropeway = rw;
				e.pos = EngineVO.FIRST;
				engineTempProxy.list.addItem(e);
				
				e = new EngineVO;
				e.ropeway = rw;
				e.pos = EngineVO.SECOND;
				engineTempProxy.list.addItem(e);
			}
			
			//初始化吊箱
			var carriageProxy:CarriageProxy = facade.retrieveProxy(CarriageProxy.NAME) as CarriageProxy;
			carriageProxy.Init().addResponder(new AsyncResponder(onCarriageInit,onFault));
			
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

	}
}