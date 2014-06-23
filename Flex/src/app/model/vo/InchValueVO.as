package app.model.vo
{
	[Bindable]
	public class InchValueVO
	{
		public var alarm:int;
		
		public var date:Date;
		
		public var temp:Number = 0;
		
		public var humi:Number = 0;
		
		public var value:Number = 0;
		
		public function InchValueVO()
		{
		}
	}
}