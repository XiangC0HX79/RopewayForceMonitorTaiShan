package app.model.vo
{
	[Bindable]
	public class WindValueVO implements IDateValue,IAlarmValue
	{
		public static var MAX_SPEED:Number = 15;
		
		public var speed:Number = 0;
		
		public var date:Date;
		
		public function get alarm():int
		{
			return (speed > MAX_SPEED)?1:0;
		}
		
		public function set alarm(value:int):void
		{
			// TODO Auto Generated method stub			
		}		
		
		public var dir:Number = 0;
		
		public function WindValueVO()
		{
		}
	}
}