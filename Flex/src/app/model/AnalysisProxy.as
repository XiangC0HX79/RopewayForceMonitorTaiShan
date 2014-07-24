package app.model
{	
	import com.adobe.serialization.json.JSON;
	
	import flash.errors.IllegalOperationError;
	import flash.globalization.DateTimeFormatter;
	import flash.net.URLVariables;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import app.controller.notify.AnalysisNotify;
	import app.controller.notify.AnalysisValueChartNotify;
	import app.controller.notify.AnalysisValueTableNotify;
	import app.model.vo.AnalysisAverageVO;
	import app.model.vo.DeviceVO;

	public class AnalysisProxy extends WebServiceProxy implements IAnalysisProxy
	{		
		public function AnalysisProxy(proxyName:String=null, data:Object=null)
		{
			super(proxyName, data);
		}
						
		protected function facatoryCreate(item:*):Object
		{
			throw(new IllegalOperationError("调用抽象方法"));					
		}
		
		protected function callTableMethod(notify:AnalysisValueTableNotify):AsyncToken
		{
			throw(new IllegalOperationError("调用抽象方法"));				
		}
		
		protected function callChartMethod(notify:AnalysisValueChartNotify):AsyncToken
		{
			throw(new IllegalOperationError("调用抽象方法"));				
		}
		
		protected function callDayAveMethod(notify:AnalysisNotify):AsyncToken
		{
			throw(new IllegalOperationError("调用抽象方法"));				
		}
		
		protected function callMonthAveMethod(notify:AnalysisNotify):AsyncToken
		{
			throw(new IllegalOperationError("调用抽象方法"));				
		}
				
		public function GetChartList(notify:AnalysisValueChartNotify):AsyncToken
		{			
			var token:AsyncToken = callChartMethod(notify);
			token.addResponder(new AsyncResponder(GetChartListResult,function onFault(error:FaultEvent, token:Object = null):void{}));
			token.resultHandle = notify.ResultHandle;
			return token;
		}
		
		private function GetChartListResult(result:ResultEvent, token:Object = null):void
		{			
			var jd:* = JSON.decode(String(result.result));
			
			var chartInfo:* = jd.ChartInfo[0];
			
			var colChart:ArrayCollection = new ArrayCollection;
			
			for each(var item:* in jd.ChartData)
			{
				colChart.addItem(facatoryCreate(item));
			}
			
			result.token.resultHandle(colChart,new Date(Date.parse(chartInfo.MinTime)),new Date(Date.parse(chartInfo.MaxTime)),chartInfo.MinValue,chartInfo.MaxValue);
		}
		
		public function GetPageData(notify:AnalysisValueTableNotify):AsyncToken
		{			
			var token:AsyncToken = callTableMethod(notify);			
			token.addResponder(new AsyncResponder(GetPageDataResult,function onFault(error:FaultEvent, token:Object = null):void{}));
			token.resultHandle = notify.ResultHandle;
			return token;
		}
			
		private function GetPageDataResult(result:ResultEvent, token:Object = null):void
		{
			var jd:* = JSON.decode(String(result.result));
			
			var totalCount:int = jd.totalCount;
			
			var colGrid:ArrayCollection = new ArrayCollection;
			
			for each(var item:* in jd.list)
			{
				colGrid.addItem(facatoryCreate(item));
			}
			
			result.token.resultHandle(totalCount,colGrid);
		}	
		
		public function ValueExport(notify:AnalysisNotify):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function AverageExportDay(notify:AnalysisNotify):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function AverageExportMonth(notify:AnalysisNotify):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function GetDayAvgList(notify:AnalysisNotify):AsyncToken
		{			
			var token:AsyncToken = callDayAveMethod(notify);	
			token.addResponder(new AsyncResponder(GetAvgListResult,function onFault(error:FaultEvent, token:Object = null):void{}));
			token.resultHandle = notify.ResultHandle;
			return token;
		}
		
		public function GetMonthAvgList(notify:AnalysisNotify):AsyncToken
		{
			var token:AsyncToken = callMonthAveMethod(notify);	
			token.addResponder(new AsyncResponder(GetAvgListResult,function onFault(error:FaultEvent, token:Object = null):void{}));
			token.resultHandle = notify.ResultHandle;
			return token;
		}
		
		private function GetAvgListResult(result:ResultEvent, token:Object = null):void
		{			
			var colWindAve:ArrayCollection = new ArrayCollection;
			
			for each(var item:* in result.result)
			{
				colWindAve.addItem(new AnalysisAverageVO(item));
			}
			
			result.token.resultHandle(colWindAve);
		}
	}
}