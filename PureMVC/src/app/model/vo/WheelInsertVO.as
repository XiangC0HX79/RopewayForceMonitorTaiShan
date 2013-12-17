package app.model.vo
{
	import mx.utils.*;
	
	[Bindable]
	public class WheelInsertVO
	{
		public var WheelId:String;
		
		public var LineAreaId:int;
		
		public var Id:int;
		
		public var RopeWay:String;
		
		public var Status:String = "black";
		
		public var Is_Delete:int = 0;
		
		public var WheelType:String = "1";
		
		public function WheelInsertVO(o:*)
		{
			WheelId = o.WheelId;
			LineAreaId = o.LineAreaId;
			Id = o.Id;
			RopeWay = o.RopeWay;
			WheelType = o.WheelType;
		}
		
		public function get obj():Object
		{
			var o:Object = {};
			o.WheelId = WheelId;
			o.LineAreaId = LineAreaId;
			o.Id = Id;
			o.RopeWay = RopeWay;
			o.WheelType = WheelType;
			o.Is_Delete = Is_Delete;
			
			return o;
		}
	}
}