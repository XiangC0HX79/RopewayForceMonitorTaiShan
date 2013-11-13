package app.model.vo
{
	import mx.formatters.DateFormatter;
	import mx.utils.*;
	
	[Bindable]
	public class StandConfigVO
	{
		//public var Id:int;
		
		//public var FormName:String;
		
		public var RopeWay:String;
		
		//public var BracketId:int;
		
		public var CheckItemIdPairs:String = "";
		
		public var CheckItemNamePairs:String = "";
		
		//public var Memo:String = "";
		
		//public var Is_Delete:int = 0;
		
		//public var LastEditTime:Date;
		
		//public var LastEditUser:String;
		
		//public var Extent1:String = "";
		//public var Extent2:String = "";
		
		public function StandConfigVO(o:Object)
		{
			RopeWay = o.RopeWay;
			//BracketId = o.BracketId;
			//Id = o.Id;
			//FormName = o.FormName;
			CheckItemIdPairs = o.CheckItemIdPairs
			CheckItemNamePairs = o.CheckItemNamePairs;
			/*Memo = o.Memo;
			Is_Delete = o.Is_Delete;
			var dateFormatter:DateFormatter = new DateFormatter();
			dateFormatter.formatString = "YYYY-MM-DD JJ:NN:SS";
			LastEditTime = o.LastEditTime;
			LastEditUser = o.LastEditUser;*/
		}
	}
}