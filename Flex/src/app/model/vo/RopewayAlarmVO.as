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
		 * 吊箱编号
		 **/
		public function get carId():String
		{
			return _source.CarId;
		}
		public function set carId(value:String):void
		{
			_source.CarId = value;
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
		public function set alarmDate(value:Date):void
		{
			_source.AlarmDatetime = value;
		}
		
		/**
		 * 报警描述
		 **/
		public function get alarmDesc():String
		{
			return _source.AlarmDesc;
		}
		public function set alarmDesc(value:String):void
		{
			_source.AlarmDesc = value;
		}
		
		public function RopewayAlarmVO(value:*)
		{
			_source = value;
		}
	}
}