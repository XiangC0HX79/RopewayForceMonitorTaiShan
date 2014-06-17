package app.controller
{	
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import mx.collections.ArrayCollection;
	
	import spark.components.Application;
	
	import app.model.CarriageEditHisProxy;
	import app.model.CarriageProxy;
	import app.model.ConfigProxy;
	import app.model.EngineTempProxy;
	import app.model.ForceRealtimeDetectionAlarmProxy;
	import app.model.InchHistoryProxy;
	import app.model.InchProxy;
	import app.model.RopeForceAjustProxy;
	import app.model.RopewayAlarmAnalysisProxy;
	import app.model.RopewayForceAverageProxy;
	import app.model.RopewayForceProxy;
	import app.model.RopewaySwitchFreqProxy;
	import app.model.RopewaySwitchFreqTotalProxy;
	import app.model.SurroundingTempProxy;
	import app.model.dict.RopewayDict;
	import app.model.dict.RopewayStationDict;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class ModelPreCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			//初始化索道
			RopewayDict.dict = new Dictionary;			
			RopewayDict.dict[RopewayDict.ZHONG_TIAN_MEN.fullName] = RopewayDict.ZHONG_TIAN_MEN;
			RopewayDict.dict[RopewayDict.TAO_HUA_YUAN.fullName] = RopewayDict.TAO_HUA_YUAN;
			
			var r:Array = [];			
			for each(var rw:RopewayDict in RopewayDict.dict)
				r.push(rw);			
			r.sortOn("id",Array.NUMERIC);			
			RopewayDict.list = new ArrayCollection(r);
			
			//初始化索道站			
			RopewayStationDict.dict = new Dictionary;
			for each(rw in RopewayDict.dict)
			{				
				var rs:RopewayStationDict = new RopewayStationDict;			
				rs.ropeway = rw;
				rs.ropewayId = rw.id;
				rs.station = RopewayStationDict.FIRST;	
				RopewayStationDict.dict[rs.fullName] = rs;
				
				rs = new RopewayStationDict();
				rs.ropeway = rw;
				rs.ropewayId = rw.id;
				rs.station = RopewayStationDict.SECOND;	
				RopewayStationDict.dict[rs.fullName] = rs;
			}
			
			r = [];			
			for each(rs in RopewayStationDict.dict)
				r.push(rs);			
			r.sortOn(["ropewayId","station"],[Array.NUMERIC,Array.NUMERIC]);			
			RopewayStationDict.list =  new ArrayCollection(r);
			
			facade.registerProxy(new ConfigProxy);
			facade.registerProxy(new ForceRealtimeDetectionAlarmProxy);
			facade.registerProxy(new RopewayForceProxy);
			facade.registerProxy(new RopewayForceAverageProxy);
			facade.registerProxy(new RopewaySwitchFreqProxy);
			facade.registerProxy(new RopewaySwitchFreqTotalProxy);
			facade.registerProxy(new RopewayAlarmAnalysisProxy);			
			facade.registerProxy(new CarriageProxy);			
			facade.registerProxy(new CarriageEditHisProxy);	
			facade.registerProxy(new RopeForceAjustProxy);
			
			facade.registerProxy(new SurroundingTempProxy);
			facade.registerProxy(new EngineTempProxy);
			facade.registerProxy(new InchProxy);
			facade.registerProxy(new InchHistoryProxy);
		}
	}
}