package app.model.vo
{
	import mx.utils.*;

	[Bindable]
	public class WheelManageVO
	{
		public var WheelId:String;
		
		public var LineAreaId:int;
		
		public var Id:int;
		
		public var RopeWay:String;
		
		public var Status:String = "black";
		
		public var Is_Delete:int;
		
		public var WheelType:String = "1";
		
		public var wheelHis:AreaWheelVO = new AreaWheelVO();
		
		public function WheelManageVO(o:*)
		{
			WheelId = o.WheelId;
			LineAreaId = o.LineAreaId;
			Id = o.Id;
			RopeWay = o.RopeWay;
			Is_Delete = o.Is_Delete;
			WheelType = o.WheelType;
		}
		
		/*public function toString(obj:Object):String
		{
			return JSON.stringify(obj.valueOf());
		}*/
	}
}