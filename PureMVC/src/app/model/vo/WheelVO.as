package app.model.vo
{
	import mx.collections.ArrayCollection;
	import mx.utils.*;

	[Bindable]
	public class WheelVO
	{
		public var RopeWay:String;
		
		public var AreaId:int;
		
		public var MaintainType:int;
		
		public var WheelId:String;
		
		public var MaintainTime:Date;
		
		public var HourDiff:Number;
		
		public var StandName:int;
		
		public var AreaWheel:ArrayCollection;
		
		public function WheelVO(o:*)
		{
			RopeWay = o.RopeWay;
			AreaId = o.LineAreaId;
			HourDiff = o.HourDiff;
			WheelId = o.WheelId;
			MaintainType = o.MaintainType;
			MaintainTime = new Date(Date.parse(o.MaintainTime));
		}
	}
}