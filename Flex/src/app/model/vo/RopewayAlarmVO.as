package app.model.vo
{
	[Bindable]
	public class RopewayAlarmVO
	{
		private var _source:*;
		
		/**
		 * 抱索器编号
		 **/
		public function get ropeCode():String
		{
			return _source.RoapCode;
		}
		public function set ropeCode(value:String):void
		{
			_source.RoapCode = value;
		}
		
		/**
		 * 报警类型
		 **/
		public function get alarmType():String
		{
			return _source.AlarmType;
		}
		public function set alarmType(value:String):void
		{
			_source.AlarmType = value;
		}
		
		/**
		 * 报警时间
		 **/
		public function get alarmDate():Date
		{
			return _source.AlarmDatetime;
		}
		public function set alarmType(value:Date):void
		{
			_source.AlarmDatetime = value;
		}
		
		public function RopewayAlarmVO(value:*)
		{
			_source = value;
		}
	}
}