package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.ContentTodayOverview;
	
	import custom.itemRenderer.ItemRendererTodayOverview;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ISort;
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.collections.Sort;
	
	public class ContentTodayOverviewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentTodayOverviewMediator";
				
		public static const ONE_MIN:Number = 60 * 1000;
		public static const TEN_MIN:Number = 10 * 60 * 1000;
		public static const HALF_HOUR:Number = 30 * 60 * 1000;
		public static const ONE_HOUR:Number = 60 * 60 * 1000;
		
		private var _ropewayProxy:RopewayProxy;
		
		public function ContentTodayOverviewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			//contentTodayOverview.addEventListener(FlexEvent.CREATION_COMPLETE,onCreate);
			contentTodayOverview.addEventListener(ResizeEvent.RESIZE,onResize);
			
			contentTodayOverview.addEventListener(ContentTodayOverview.ITEM_CLICK,onItemCLick);
			
			_ropewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;				
		}
		
		protected function get contentTodayOverview():ContentTodayOverview
		{
			return viewComponent as ContentTodayOverview;
		}
		
		private function onCreate(event:FlexEvent):void
		{			
			var w:Number = 240;
			
			var numW:Number = Math.floor(contentTodayOverview.dataGroup.width / w);
			
			contentTodayOverview.pageSize = numW * 2;
						
			contentTodayOverview.colDp.source = contentTodayOverview.arrDp.slice(0
				,Math.min(contentTodayOverview.arrDp.length,contentTodayOverview.pageSize));
		}
		
		private function onResize(event:ResizeEvent):void
		{			
			var w:Number = 240;
			
			var numW:Number = Math.floor((contentTodayOverview.width - 30)/ w);
			
			contentTodayOverview.pageIndex = 0;
			
			contentTodayOverview.pageSize = numW * 2;
			
			contentTodayOverview.colDp.source = contentTodayOverview.arrDp.slice(0
				,Math.min(contentTodayOverview.arrDp.length,contentTodayOverview.pageSize));
			
			flash.utils.setTimeout(drawYesterday,200);
		}
		
		private function changeStation(station:String):void
		{						
			contentTodayOverview.arrDp = [];
			
			for each(var r:RopewayStationForceVO in _ropewayProxy.colRopeway)
			{
				//if((r.ropewayStation == station) && (r.deteDate.toDateString() == (new Date).toDateString()))
				//	contentTodayOverview.arrDp.push(r);
			}
			
			contentTodayOverview.arrDp.sortOn("ropewayCarId");
			
			contentTodayOverview.pageIndex = 0;
			
			contentTodayOverview.colDp.source = contentTodayOverview.arrDp.slice(0
				,Math.min(contentTodayOverview.arrDp.length,contentTodayOverview.pageSize));
		}
		
		private function onItemCLick(event:Event):void
		{
			if(!contentTodayOverview.ropeway.ropewayHistory)
			{				
				var token:AsyncToken = _ropewayProxy.LoadRopeWayForceHis(contentTodayOverview.ropeway);
				token.addResponder(new AsyncResponder(onLoadRopeWayForceHis,function(fault:FaultEvent,t:Object):void{}));
			}
			else
			{
				reCalcuXY();
			}
		}
		
		private function onLoadRopeWayForceHis(event:ResultEvent,t:Object):void
		{			
			reCalcuXY();
		}
				
		private function reCalcuY():void
		{			
			var rw:RopewayStationForceVO = contentTodayOverview.ropeway;
			
			var max:Number = Math.max(rw.yesterdayMax,rw.maxValue);
			var min:Number = Math.min(rw.yesterdayMin,rw.minValue);
			
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
			
			contentTodayOverview.verticalAxis.interval = interval;
			contentTodayOverview.verticalAxis.minimum = (min > 0)?min:0;
			contentTodayOverview.verticalAxis.maximum = min + 5 * interval;
		}
		
		private function reCalcuX():void
		{			
			var rw:RopewayStationForceVO = contentTodayOverview.ropeway;
			
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
			
			contentTodayOverview.horizontalAxis.labelUnits = labelUnits;
			contentTodayOverview.horizontalAxis.interval = interval;
			contentTodayOverview.horizontalAxis.minimum = new Date(min);
			contentTodayOverview.horizontalAxis.maximum = new Date(max);
		}
		
		private function drawYesterday():void
		{
			var rw:RopewayStationForceVO = contentTodayOverview.ropeway;
			
			if(rw && rw.yesterdayMax && rw.yesterdayMin)
			{					
				//昨天数值
				contentTodayOverview.lineMax.visible = true;
				contentTodayOverview.lineMin.visible = true;
				contentTodayOverview.lineAve.visible = true;
				contentTodayOverview.lbMax.visible = true;
				contentTodayOverview.lbMin.visible = true;
				contentTodayOverview.lbAve.visible = true;
				
				var moves:Array = new Array;
				
				var pt:Point = contentTodayOverview.dataCanvas.dataToLocal(0,rw.yesterdayMax);	
				contentTodayOverview.lineMax.y = pt.y;
				//contentTodayOverview.lbMax.y = pt.y + 20;
				
				pt = contentTodayOverview.dataCanvas.dataToLocal(0,rw.yesterdayAve);
				contentTodayOverview.lineAve.y = pt.y;
				//contentTodayOverview.lbAve.y = pt.y + 20;
				
				pt = contentTodayOverview.dataCanvas.dataToLocal(0,rw.yesterdayMin);
				contentTodayOverview.lineMin.y = pt.y;
				//contentTodayOverview.lbMin.y = pt.y + 20;
				
				/*var move:Move = new Move(contentTodayOverview.lineMax);
				move.yTo = pt.y;
				moves.push(move);
				
				move = new Move(contentTodayOverview.lbMax);
				move.yTo = pt.y + 20;
				moves.push(move);
				
				move = new Move(contentTodayOverview.lineAve);
				move.yTo = pt.y;
				moves.push(move);
				
				move = new Move(contentTodayOverview.lbAve);
				move.yTo = pt.y + 20;
				moves.push(move);
				
				move = new Move(contentTodayOverview.lineMin);
				move.yTo = pt.y;
				moves.push(move);
				
				move = new Move(contentTodayOverview.lbMin);
				move.yTo = pt.y + 20;
				moves.push(move);
				
				contentTodayOverview.parallel.end();
				contentTodayOverview.parallel.children = moves;
				contentTodayOverview.parallel.play();*/
			}
			else
			{
				contentTodayOverview.lineMax.visible = false;
				contentTodayOverview.lineMin.visible = false;
				contentTodayOverview.lineAve.visible = false;
				contentTodayOverview.lbMax.visible = false;
				contentTodayOverview.lbMin.visible = false;
				contentTodayOverview.lbAve.visible = false;
			}
		}
		
		private function reCalcuXY():void
		{			
			reCalcuY();
			
			reCalcuX();
			
			drawYesterday();
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				
				ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE,
				
				ApplicationFacade.NOTIFY_MENU_TODAY_OVERVIEW,
				
				ApplicationFacade.NOTIFY_SOCKET_FORCE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_MAIN_STATION_CHANGE:
				case ApplicationFacade.NOTIFY_INIT_APP_COMPLETE:
				case ApplicationFacade.NOTIFY_MENU_TODAY_OVERVIEW:
					var configProxy:ConfigProxy = facade.retrieveProxy(ConfigProxy.NAME) as ConfigProxy;
					changeStation(configProxy.config.station);
					break;
				
				case ApplicationFacade.NOTIFY_SOCKET_FORCE:
					var rw:RopewayStationForceVO = notification.getBody() as RopewayStationForceVO;					
					if(rw == contentTodayOverview.ropeway)
						reCalcuXY();
					break;
			}
		}
	}
}