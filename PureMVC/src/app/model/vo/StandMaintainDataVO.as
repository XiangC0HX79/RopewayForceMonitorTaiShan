package app.model.vo
{
	import mx.formatters.DateFormatter;
	import mx.utils.*;
	
	[Bindable]
	public class StandMaintainDataVO
	{
		public var MId:int;
		
		public var CheckItemId:int;
		
		
		public var CheckItemName:String;
		
		public var CheckData:String = "";
		public var Memo:String = "";
		
		public function StandMaintainDataVO()
		{
			/*CheckItemId = o.CheckItemId;
			Mid = o.Mid;
			CheckData = o.CheckData;
			CheckItemName = o.CheckItemName;*/
		}
	}
}