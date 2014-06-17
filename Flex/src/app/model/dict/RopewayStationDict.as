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
		
		public function get fullName():String
		{
			return ropeway.lable + (station == FIRST?"驱动站":"回转站");
		}		
		public function set fullName(value:String):void
		{
			//return ropeway.lable + (station == FIRST?"驱动站":"回转站");
		}
		
		public static var dict:Dictionary;
		
		public static var list:ArrayCollection;
		
		public function RopewayStationDict()
		{
		}
	}
}