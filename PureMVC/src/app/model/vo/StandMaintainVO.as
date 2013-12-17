package app.model.vo
{
	import mx.formatters.DateFormatter;
	
	[Bindable]
	public class StandMaintainVO
	{
		public var Id:int;
		
		public var RopeWay:String;
		
		public var BracketId:int;
		
		public var MDate:Date;
		
		public var InputUserId:int;
		
		public var InputUserName:String;
		
		public var Extent1:String = "";
		public var Extent2:String = "";
		public function StandMaintainVO(o:*)
		{
			RopeWay = o.RopeWay;
			BracketId = o.BracketId;
			Id = o.Id;
			var dateFormatter:DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
			MDate = new Date(Date.parse(o.MDate));
			InputUserName = o.InputUserName;
		}
	}
}