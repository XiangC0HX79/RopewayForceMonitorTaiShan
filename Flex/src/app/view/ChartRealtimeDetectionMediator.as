package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayVO;
	import app.view.components.ChartImage;
	import app.view.components.ChartRealtimeDetection;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.effects.Move;
	
	public class ChartRealtimeDetectionMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ChartRealtimeDetectionMediator";
		
		public static const ONE_MIN:Number = 60 * 1000;
		public static const TEN_MIN:Number = 10 * 60 * 1000;
		public static const HALF_HOUR:Number = 30 * 60 * 1000;
		public static const ONE_HOUR:Number = 60 * 60 * 1000;
		
		private var _ropewayProxy:RopewayProxy;
		
		public function ChartRealtimeDetectionMediator()
		{
			super(NAME, new ChartRealtimeDetection);
			
			//chartRealtimeDetection.addEventListener(ChartRealtimeDetection.CONTAINER_CREATE,onCreate);
			
			chartRealtimeDetection.addEventListener(ChartRealtimeDetection.CONTAINER_RESIZE,onResize);
			
			_ropewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
		}
		
		protected function get chartRealtimeDetection():ChartRealtimeDetection
		{
			return viewComponent as ChartRealtimeDetection;
		}
		
		private function onCreate(event:Event):void
		{
			if(chartRealtimeDetection.ropeway)
			{
				reCalcuXY();			
				
				chartRealtimeDetection.RefreshChart();
			}
		}
		
		private function onResize(event:Event):void			
		{
			if(chartRealtimeDetection.ropeway)
			{
				reCalcuXY();			
				
				chartRealtimeDetection.MoveChart();
			}
		}
		
		private function changeStation(station:String):void
		{			
			chartRealtimeDetection.ropeway = _ropewayProxy.GetRopewayByStation(station);
			
			if(chartRealtimeDetection.ropeway)
			{
				if(chartRealtimeDetection.ropeway.ropewayHistory)
				{
					reCalcuXY();					
					chartRealtimeDetection.RefreshChart();
				}
				else
				{
					var token:AsyncToken = _ropewayProxy.LoadRopeWayForceHis(chartRealtimeDetection.ropeway);
					token.addResponder(new AsyncResponder(onLoadRopeWayForceHis,function(fault:FaultEvent,t:Object):void{}));
				}
			}
			else
			{				
				chartRealtimeDetection.groupPoint.removeAllElements();
				chartRealtimeDetection.groupLine.removeAllElements();
				
				chartRealtimeDetection.lineMax.visible = false;
				chartRealtimeDetection.lineMin.visible = false;
				chartRealtimeDetection.lineAve.visible = false;
				chartRealtimeDetection.lbMax.visible = false;
				chartRealtimeDetection.lbMin.visible = false;
				chartRealtimeDetection.lbAve.visible = false;
			}
		}
		
		private function onLoadRopeWayForceHis(event:ResultEvent,t:Object):void
		{			
			reCalcuXY();					
			chartRealtimeDetection.RefreshChart();
		}
		
		private function reCalcuY():void
		{			
			var rw:RopewayVO = chartRealtimeDetection.ropeway;
			
			if(!rw)
				return;
			
			var max:Number = (rw.maxValue >0 )?Math.max(rw.yesterdayMax,rw.maxValue):rw.yesterdayMax;
			var min:Number = (rw.minValue > 0)?Math.min(rw.yesterdayMin,rw.minValue):rw.yesterdayMin;
				
			var df:Number = max - min;
			var ave:Number = (max + min) / 2;
			
			if(df < 4 * 10)
			{
				var interval:Number = 10;
			}
			else if(df < 4 * 20)
			{
				interval = 20;
			}
			else if(df < 4 * 50)
			{
				interval = 50;
			}
			else if(df < 4 * 100)
			{
				interval = 100;
			}
			else
			{				
				min = Math.floor(min / 200) * 200;
				max = Math.ceil(max / 200) * 200;
				
				interval = (max - min) / 5;
			}
			
			min = Math.floor(ave / interval) * interval - 2 * interval;
			
			chartRealtimeDetection.verticalAxis.interval = interval;
			chartRealtimeDetection.verticalAxis.minimum = (min > 0)?min:0;
			chartRealtimeDetection.verticalAxis.maximum = min + 5 * interval;
		}
		
		private function reCalcuX():void
		{			
			var rw:RopewayVO = chartRealtimeDetection.ropeway;
			
			if(!rw)
				return;			
			
			var min:Number = rw.ropewayHistory[0].ropewayTime.time;	
			min = Math.floor(min / ONE_MIN) * ONE_MIN;
			
			var max:Number = rw.deteDate.time;	
			max = Math.floor(max / ONE_MIN) * ONE_MIN + ONE_MIN;		
			
			var df:Number = max - min;
			
			if(df <= 10 * TEN_MIN)
			{					
				var labelUnits:String = "minutes";
				var interval:Number = Math.ceil(df / TEN_MIN);
				
				max = min + interval * TEN_MIN;
			}
			else if(df <= 10 * HALF_HOUR)
			{
				labelUnits = "minutes";
				interval = 30;
				
				min = Math.floor(min / HALF_HOUR) * HALF_HOUR;
				max = Math.ceil(max / HALF_HOUR) * HALF_HOUR;				
			}
			else
			{
				labelUnits = "hours";
				interval = 1;
				
				min = Math.floor(min / ONE_HOUR) * ONE_HOUR;
				max = Math.ceil(max / ONE_HOUR) * ONE_HOUR;
			}
			
			chartRealtimeDetection.horizontalAxis.labelUnits = labelUnits;
			chartRealtimeDetection.horizontalAxis.interval = interval;
			chartRealtimeDetection.horizontalAxis.minimum = new Date(min);
			chartRealtimeDetection.horizontalAxis.maximum = new Date(max);
		}
		
		private function drawYesterday():void
		{
			var rw:RopewayVO = chartRealtimeDetection.ropeway;
			
			if(rw && rw.yesterdayMax && rw.yesterdayMin)
			{					
				//昨天数值
				chartRealtimeDetection.lineMax.visible = true;
				chartRealtimeDetection.lineMin.visible = true;
				chartRealtimeDetection.lineAve.visible = true;
				chartRealtimeDetection.lbMax.visible = true;
				chartRealtimeDetection.lbMin.visible = true;
				chartRealtimeDetection.lbAve.visible = true;
				
				var moves:Array = new Array;
				
				var pt:Point = chartRealtimeDetection.dataCanvas.dataToLocal(0,rw.yesterdayMax);				
				var move:Move = new Move(chartRealtimeDetection.lineMax);
				move.yTo = pt.y;
				moves.push(move);
				
				move = new Move(chartRealtimeDetection.lbMax);
				move.yTo = pt.y + 20;
				moves.push(move);
				
				pt = chartRealtimeDetection.dataCanvas.dataToLocal(0,rw.yesterdayAve);
				move = new Move(chartRealtimeDetection.lineAve);
				move.yTo = pt.y;
				moves.push(move);
				
				move = new Move(chartRealtimeDetection.lbAve);
				move.yTo = pt.y + 20;
				moves.push(move);
				
				pt = chartRealtimeDetection.dataCanvas.dataToLocal(0,rw.yesterdayMin);
				move = new Move(chartRealtimeDetection.lineMin);
				move.yTo = pt.y;
				moves.push(move);
				
				move = new Move(chartRealtimeDetection.lbMin);
				move.yTo = pt.y + 20;
				moves.push(move);
				
				chartRealtimeDetection.parallel.end();
				chartRealtimeDetection.parallel.children = moves;
				chartRealtimeDetection.parallel.play();
			}
			else
			{
				chartRealtimeDetection.lineMax.visible = false;
				chartRealtimeDetection.lineMin.visible = false;
				chartRealtimeDetection.lineAve.visible = false;
				chartRealtimeDetection.lbMax.visible = false;
				chartRealtimeDetection.lbMin.visible = false;
				chartRealtimeDetection.lbAve.visible = false;
			}
		}
		
		private function reCalcuXY():void
		{			
			reCalcuY();
			
			reCalcuX();
			
			drawYesterday();
		}
				
		private function clearChart():void
		{			
			chartRealtimeDetection.groupPoint.removeAllElements();
			chartRealtimeDetection.groupLine.removeAllElements();
			
				
			chartRealtimeDetection.lineMax.visible = false;
			chartRealtimeDetection.lineMin.visible = false;
			chartRealtimeDetection.lineAve.visible = false;
			chartRealtimeDetection.lbMax.visible = false;
			chartRealtimeDetection.lbMin.visible = false;
			chartRealtimeDetection.lbAve.visible = false;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
				ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME,
				ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE:
					changeStation(String(notification.getBody()));
					break;
					
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME:
					var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					
					var rw:RopewayVO = notification.getBody() as RopewayVO;		
					
					if(!rw)
					{
						clearChart();
					}
					else
					{
						if(chartRealtimeDetection.ropeway == rw)
						{						
							reCalcuXY();
							
							chartRealtimeDetection.ContinueChart();
						}
						else if(!configProxy.config.pin)
						{
							chartRealtimeDetection.ropeway = rw;
							
							reCalcuXY();
							
							chartRealtimeDetection.RefreshChart();			
						}
					}
					break;
			}
		}
	}
}