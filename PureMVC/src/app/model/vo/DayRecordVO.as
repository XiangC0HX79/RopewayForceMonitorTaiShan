package app.model.vo
{
	import mx.utils.*;
	
	[Bindable]
	public class DayRecordVO
	{
		public var Id:int;
		
		public var RopeWay:String;
		
		public var Datetime:Date;
		
		public var TodayRunTime:Number;
		
		private var _o:*;
		public function DayRecordVO(o:*)
		{
			Id = o.Id;
			RopeWay = o.RopeWay;
			Datetime = new Date(Date.parse(o.Date));
			TodayRunTime = o.TodayRunTime;
		}
	}
}