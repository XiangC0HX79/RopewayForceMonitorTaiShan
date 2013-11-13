package app.model.vo
{
	import mx.utils.*;

	[Bindable]
	public class WheelHistoryVO
	{
		public var Id:int;
		
		public var WheelId:String;
		
		public var MaintainInfo:String;
		
		public var MaintainType:String;
		
		public var MaintainTime:Date;
		
		public var MaintainUser:String;
		
		public var MaintainTips:String;
		
		public var Memo:String;
		
		private var _o:*;
		
		public function WheelHistoryVO(o:*)
		{
			Id = o.Id;
			WheelId = o.WheelId;
			MaintainInfo = o.MaintainInfo;
			MaintainType = o.MaintainType;
			MaintainTime = new Date(Date.parse(o.MaintainTime));
			MaintainUser = o.MaintainUser;
			MaintainTips = o.MaintainTips;
			Memo = o.Memo;
			_o = o;
		}
		
		
		public function toString(obj:Object):String
		{
			return JSON.stringify(obj.valueOf());
		}
	}
}