package model
{
	import flash.utils.Dictionary;
	
	[Bindable]
	public class ChartData
	{
		public var xField:Date;
		
		public var yField:Number;
		
		public var actField:String;
		
		public var data:Dictionary = new Dictionary;
		
		public function ChartData()
		{
		}
	}
}