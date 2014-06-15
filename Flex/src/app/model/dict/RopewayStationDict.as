package app.model.dict
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class RopewayStationDict
	{
		public static const FIRST:int = 1;
		
		public static const SECOND:int = 2;
		
		public var ropeway:RopewayDict;
		
		public var ropewayId:int;
		
		public var station:int;
		
		public var alarmForce:Number = 50;
		
		public static var dict:Dictionary;
		
		public function get fullName():String
		{
			return ropeway.lable + (station == FIRST?"驱动站":"回转站");
		}		
		public function set fullName(value:String):void
		{
			//return ropeway.lable + (station == FIRST?"驱动站":"回转站");
		}
		
		public static function get list():ArrayCollection
		{
			var r:Array = [];
			
			for each(var rs:RopewayStationDict in RopewayStationDict.dict)
			{				
				r.push(rs);
			}
			
			r.sortOn(["ropewayId","station"],[Array.NUMERIC,Array.NUMERIC]);
			
			return new ArrayCollection(r);
		}
		
		public function RopewayStationDict()
		{
		}
	}
}