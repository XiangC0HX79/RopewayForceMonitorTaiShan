package forceMonitor.model.vo
{
	import com.adobe.serialization.json.JSON;

	[Bindable]
	public class RopewayAlarmVO
	{
		/**
		 * 主键
		 **/
		public function get id():Number
		{
			return _source.Id;
		}
		public function set id(value:Number):void
		{
			_source.Id = value;
		}
		
		/**
		 * 抱索器编号
		 **/
		public function get ropeCode():String
		{
			return _source.RopeCode;
		}
		public function set ropeCode(value:String):void
		{
			_source.RopeCode = value;
		}
		
		/**
		 * 吊箱编号
		 **/
		public function get carId():String
		{
			return _source.CarriageCode;
		}
		public function set carId(value:String):void
		{
			_source.CarriageCode = value;
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
		
		/**
		 * 所属索道站
		 **/
		public function get fromRopeStation():String	
		{
			return _source.FromRopeStation;
		}
		public function set fromRopeStation(value:String):void	
		{
			_source.FromRopeStation = value;
		}
		
		/**
		 * 所属索道
		 **/
		public function get fromRopeWay():String	
		{
			return _source.FromRopeWay;
		}
		public function set fromRopeWay(value:String):void	
		{
			_source.FromRopeWay = value;
		}
		
		/**
		 * 处置人
		 **/
		public function get dealUser():String
		{
			return _source.DealUser;
		}
		public function set dealUser(value:String):void
		{
			_source.DealUser = value;
		}
				
		/**
		 * 处置时间
		 **/
		public function get dealDatetime():Date
		{
			return _source.DealDatetime;
		}
		public function set dealDatetime(value:Date):void
		{
			_source.DealDatetime = value;
		}
		
		/**
		 * 处置描述
		 **/
		public function get dealDesc():String
		{
			return _source.DealDesc;
		}
		public function set dealDesc(value:String):void
		{
			_source.DealDesc = value;
		}
		
		/**
		 * 备注
		 **/
		public function get memo():String
		{
			return _source.Memo;
		}
		public function set memo(value:String):void
		{
			_source.Memo = value;
		}
		
		private var _source:*;		
		
		public function RopewayAlarmVO(value:*)
		{
			_source = value;
		}
		
		public function toString():String
		{
			return JSON.encode(_source);
		}
	}
}