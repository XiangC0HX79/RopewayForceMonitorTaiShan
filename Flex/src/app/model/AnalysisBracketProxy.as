package app.model
{		
	import mx.rpc.AsyncToken;
	
	import app.controller.notify.AnalysisNotify;
	import app.controller.notify.AnalysisValueChartNotify;
	import app.controller.notify.AnalysisValueTableNotify;
	import app.model.vo.AnalysisWindVO;

	public class AnalysisBracketProxy extends AnalysisProxy
	{
		public static const NAME:String = "AnalysisBracketProxy";
		
		public function AnalysisBracketProxy()
		{
			super(NAME);
		}
		
		override protected function facatoryCreate(item:*):Object
		{
			return AnalysisWindVO.facatoryCreate(item);					
		}
		
		override protected function callTableMethod(notify:AnalysisValueTableNotify):AsyncToken
		{		
			return send("T_JC_WindSpeedHisBLL_GetPageData",notify.device.ropeway.fullName,notify.device.deviceId,notify.sTime,notify.eTime,notify.pageIndex,notify.pageSize)
		}
		
		override protected function callChartMethod(notify:AnalysisValueChartNotify):AsyncToken
		{
			return sendNoBusy("T_JC_WindSpeedHisBLL_GetChartList",notify.device.ropeway.fullName,notify.device.deviceId,notify.sTime,notify.eTime,notify.mTime,notify.chartSize);
		}
		
		override protected function callDayAveMethod(notify:AnalysisNotify):AsyncToken
		{
			return send("T_JC_WindSpeedHisBLL_GetDayAvgStatList",notify.device.ropeway.fullName,notify.device.deviceId,notify.sTime,notify.eTime);
		}
		
		override protected function callMonthAveMethod(notify:AnalysisNotify):AsyncToken
		{
			return send("T_JC_WindSpeedHisBLL_GetMonthAvgStatList",notify.device.ropeway.fullName,notify.device.deviceId,notify.sTime,notify.eTime);
		}
				
		override public function ValueExport(notify:AnalysisNotify):void
		{
			export("WindValueExport","历史风速风向.xls",notify.averageExportVar);
		}
		
		override public function AverageExportDay(notify:AnalysisNotify):void
		{						
			export("WindAverageExportDay","平均风速风向.xls",notify.averageExportVar);
		}
		
		override public function AverageExportMonth(notify:AnalysisNotify):void
		{						
			export("WindAverageExportMonth","平均风速风向.xls",notify.averageExportVar);
		}
	}
}