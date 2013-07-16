package app.model.vo
{
	import mx.utils.ObjectProxy;
	
	[Bindable]
	public class RopewayBaseinfoHisVO
	{
		/**
		 * 抱索器编号
		 * */
		public function get ropewayId():String
		{
			return _source.RopeCode;
		}
		public function set ropewayId(value:String):void
		{
			_source.RopeCode = value;
		}
		
		/**
		 * 吊箱编号
		 * */
		public function get ropewayCarId():String
		{
			return _source.CarriageCode;
		}
		public function set ropewayCarId(value:String):void
		{
			_source.CarriageCode = value;
		}
		
		/**
		 * RFID
		 * */
		public function get ropewayRFID():String
		{
			return _source.RFIDCode;
		}
		public function set ropewayRFID(value:String):void
		{
			_source.RFIDCode = value;
		}
		
		/**
		 * 所属索道
		 **/
		public function get fromRopeWay():String	
		{
			return _source.RopeWay;
		}
		public function set fromRopeWay(value:String):void	
		{
			_source.RopeWay = value;
		}
		
		/**
		 * 更新人
		 **/
		public function get updateUser():String	
		{
			return _source.UpdateUser;
		}
		public function set updateUser(value:String):void	
		{
			_source.UpdateUser = value;
		}
		
		/**
		 * 更新时间
		 **/
		public function get updateDatetime():Date	
		{
			return _source.UpdateDatetime;
		}
		public function set updateDatetime(value:Date):void	
		{
			_source.UpdateDatetime = value;
		}
		
		
		private var _source:ObjectProxy;
		
		public function RopewayBaseinfoHisVO(source:ObjectProxy)
		{
			_source = source;			
		}
	}
}