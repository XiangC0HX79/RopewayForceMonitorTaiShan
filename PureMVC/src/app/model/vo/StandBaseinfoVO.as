package app.model.vo
{
	import mx.utils.*;
	
	[Bindable]
	public class StandBaseinfoVO
	{
		public var RopeWay:String;
		
		public var BracketId:int;
		
		public var Id:int;
		
		public var BracketInfo:String;
		
		public var LastEditUser:String = "";
		public var LastEditTie:String;
		public var Extent1:String = "";
		public var Extent2:String = "";
		public function StandBaseinfoVO(o:*)
		{
			RopeWay = o.RopeWay;
			BracketId = o.BracketId;
			Id = o.Id;
			BracketInfo = o.BracketInfo;
		}
	}
}