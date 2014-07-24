package app.controller.notify
{
	import flash.errors.IllegalOperationError;
	import flash.globalization.DateTimeFormatter;
	import flash.net.URLVariables;
	
	import app.model.AnalysisBracketProxy;
	import app.model.AnalysisEngineProxy;
	import app.model.AnalysisInchProxy;
	import app.model.vo.BracketVO;
	import app.model.vo.DeviceVO;
	import app.model.vo.EngineVO;
	import app.model.vo.InchVO;

	public class AnalysisNotify
	{
		public var device:DeviceVO;
		
		public var sTime:Date;
		public var eTime:Date;
		
		public var ResultHandle:Function;
		
		public function get analysisProxyName():String
		{
			if(device is InchVO)
				return AnalysisInchProxy.NAME;
			
			if(device is EngineVO)
				return AnalysisEngineProxy.NAME;
			
			if(device is BracketVO)
				return AnalysisBracketProxy.NAME;
			
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function get averageExportVar():URLVariables
		{
			var df:DateTimeFormatter = new DateTimeFormatter("zh_CN");
			
			var urlVar:URLVariables = new URLVariables;
			urlVar.deviceId = device.deviceId;
			urlVar.rwName = device.ropeway.fullName;
			urlVar.sTime = df.format(sTime);
			urlVar.eTime = df.format(eTime);
			
			return urlVar;
		}	
	}
}