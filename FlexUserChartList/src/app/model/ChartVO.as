package app.model
{
	[Bindable]
	public class ChartVO
	{
		public var id:int;
		
		public var barId:int;
		
		public var barImgSource:String;
		
		public var barName:String;
		
		public var barTime:Date;
		
		public var barValue:Number;
		
		public function ChartVO()
		{
		}
	}
}