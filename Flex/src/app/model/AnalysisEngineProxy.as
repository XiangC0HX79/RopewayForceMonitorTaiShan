package app.model
{
	import mx.rpc.AsyncToken;
	
	import app.controller.notify.AnalysisNotify;
	import app.controller.notify.AnalysisValueChartNotify;
	import app.controller.notify.AnalysisValueTableNotify;
	import app.model.vo.AnalysisEngineVO;
	import app.model.vo.DeviceVO;

	public class AnalysisEngineProxy extends AnalysisProxy
	{
		public static const NAME:String = "AnalysisEngineProxy";
		
		public function AnalysisEngineProxy()
		{
			super(NAME);
		}
		
		override protected function facatoryCreate(item:*):Object
		{
			return AnalysisEngineVO.facatoryCreate(item);					
		}
		
		override protected function callTableMethod(notify:AnalysisValueTableNotify):AsyncToken
		{		
			return send("T_JC_Temperature_GetPageData",notify.device.ropeway.fullName,notify.device.deviceId,notify.sTime,notify.eTime,notify.pageIndex,notify.pageSize)
		}
		
		override protected function callChartMethod(notify:AnalysisValueChartNotify):AsyncToken
		{
			return sendNoBusy("T_JC_Temperature_GetChartList",notify.device.ropeway.fullName,notify.device.deviceId,notify.sTime,notify.eTime,notify.mTime,notify.chartSize);
		}
		
		override protected function callDayAveMethod(notify:AnalysisNotify):AsyncToken
		{
			return send("T_JC_Temperature_GetDayAvgStatList",notify.device.ropeway.fullName,notify.device.deviceId,notify.sTime,notify.eTime);
		}
				
		override protected function callMonthAveMethod(notify:AnalysisNotify):AsyncToken
		{
			return send("T_JC_Temperature_GetMonthAvgStatList",notify.device.ropeway.fullName,notify.device.deviceId,notify.sTime,notify.eTime);
		}
		
		override public function ValueExport(notify:AnalysisNotify):void
		{
			export("EngineValueExport","历史动力室温度.xls",notify.averageExportVar);
		}
		
		override public function AverageExportDay(notify:AnalysisNotify):void
		{						
			export("EngineAverageExportDay","平均动力室温度.xls",notify.averageExportVar);
		}
		
		override public function AverageExportMonth(notify:AnalysisNotify):void
		{						
			export("EngineAverageExportMonth","平均动力室温度.xls",notify.averageExportVar);
		}
	}
}