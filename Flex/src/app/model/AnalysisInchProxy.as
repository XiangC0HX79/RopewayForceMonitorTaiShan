package app.model
{	
	import mx.rpc.AsyncToken;
	
	import app.controller.notify.AnalysisNotify;
	import app.controller.notify.AnalysisValueChartNotify;
	import app.controller.notify.AnalysisValueTableNotify;
	import app.model.vo.AnalysisInchVO;
	import app.model.vo.DeviceVO;

	public class AnalysisInchProxy extends AnalysisProxy
	{
		public static const NAME:String = "AnalysisInchProxy";
		
		public function AnalysisInchProxy()
		{
			super(NAME);
		}
		
		override protected function facatoryCreate(item:*):Object
		{
			return AnalysisInchVO.facatoryCreate(item);					
		}
		
		override protected function callTableMethod(notify:AnalysisValueTableNotify):AsyncToken
		{		
			return send("T_JC_ZJXC_GetPageData",notify.device.ropeway.fullName,notify.sTime,notify.eTime,notify.pageIndex,notify.pageSize)
		}
		
		override protected function callChartMethod(notify:AnalysisValueChartNotify):AsyncToken
		{
			return sendNoBusy("T_JC_ZJXC_GetChartList",notify.device.ropeway.fullName,notify.sTime,notify.eTime,notify.mTime,notify.chartSize);
		}
		
		override protected function callMonthAveMethod(notify:AnalysisNotify):AsyncToken
		{
			return send("T_JC_ZJXC_GetMonthAvgStatList",notify.device.ropeway.fullName,notify.sTime,notify.eTime);
		}
		
		override protected function callDayAveMethod(notify:AnalysisNotify):AsyncToken
		{
			return send("T_JC_ZJXC_GetDayAvgStatList",notify.device.ropeway.fullName,notify.sTime,notify.eTime);
		}
		
		override public function ValueExport(notify:AnalysisNotify):void
		{
			export("InchValueExport","历史张紧小尺.xls",notify.averageExportVar);
		}
		
		override public function AverageExportDay(notify:AnalysisNotify):void
		{						
			export("InchAverageExportDay","平均张紧小尺.xls",notify.averageExportVar);
		}
		
		override public function AverageExportMonth(notify:AnalysisNotify):void
		{						
			export("InchAverageExportMonth","平均张紧小尺.xls",notify.averageExportVar);
		}
	}
}