package app.model.vo
{
	import flash.errors.IllegalOperationError;

	[Bindable]
	public class InchValueVO implements IAlarmValue,IDateValue
	{
		public static var MAX_VALUE:Number = 8;
		public static var MIN_VALUE:Number = 2;
		
		public function get alarm():int
		{
			if(value > MAX_VALUE)
				return 1;
			
			if(value < MIN_VALUE)
				return 2;
			
			return 0;
		}
		
		public function set alarm(value:int):void
		{			
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public var date:Date = new Date;
		
		public var value:Number = 0;
		
		public function InchValueVO()
		{
		}
	}
}