package app.model.vo
{
	import flash.errors.IllegalOperationError;

	[Bindable]
	public class EngineTempVO implements IAlarmValue
	{		
		public static const MAX_VALUE:Number = 40;
		public static const MIN_VALUE:Number = -10;
		
		public var date:Date;
		
		public var temp:Number = 0;
		
		public function get alarm():int
		{
			if(temp > MAX_VALUE)
				return 1;
			
			if(temp < MIN_VALUE)
				return 2;
			
			return 0;
		}
		
		public function set alarm(value:int):void
		{			
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function EngineTempVO()
		{
		}
	}
}