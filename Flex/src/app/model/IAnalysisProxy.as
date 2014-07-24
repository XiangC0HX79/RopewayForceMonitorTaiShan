package app.model
{
	import mx.rpc.AsyncToken;
	
	import app.controller.notify.AnalysisNotify;
	import app.controller.notify.AnalysisValueChartNotify;
	import app.controller.notify.AnalysisValueTableNotify;

	public interface IAnalysisProxy
	{
		function GetPageData(notify:AnalysisValueTableNotify):AsyncToken;
		
		function GetChartList(notify:AnalysisValueChartNotify):AsyncToken;
		
		function GetDayAvgList(notify:AnalysisNotify):AsyncToken;
		
		function GetMonthAvgList(notify:AnalysisNotify):AsyncToken;
		
		function ValueExport(notify:AnalysisNotify):void;
		
		function AverageExportDay(notify:AnalysisNotify):void;
		
		function AverageExportMonth(notify:AnalysisNotify):void;
	}
}