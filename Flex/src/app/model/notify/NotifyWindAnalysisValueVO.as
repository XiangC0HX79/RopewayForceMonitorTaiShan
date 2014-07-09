package app.model.notify
{
	import app.model.vo.BracketVO;

	public class NotifyWindAnalysisValueVO
	{
		public var bracket:BracketVO;
		public var sTime:Date;
		public var eTime:Date;
		public var pageIndex:int;
		public var pageSize:int;
		
		public var ResultHandle:Function;
	}
}