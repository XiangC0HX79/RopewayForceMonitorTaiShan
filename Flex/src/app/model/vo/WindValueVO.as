package app.model.vo
{
	[Bindable]
	public class WindValueVO implements IDateValue,IAlarmValue
	{
		public var speed:Number = 0;
		
		public var date:Date;
		
		public var alarm:int;
		
		public var dir:Number = 0;
		
		public function WindValueVO()
		{
		}
	}
}