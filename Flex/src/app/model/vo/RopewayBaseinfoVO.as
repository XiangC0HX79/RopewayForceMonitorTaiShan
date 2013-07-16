package app.model.vo
{
	import mx.utils.ObjectProxy;

	[Bindable]
	public class RopewayBaseinfoVO
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
		 * 是否使用
		 * */
		public function get isUse():Boolean
		{
			return _source.IsUse == 0;
		}
		public function set isUse(value:Boolean):void
		{
			_source.IsUse = value?0:1;
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
		
		
		private var _source:ObjectProxy;
		
		public function RopewayBaseinfoVO(source:ObjectProxy = null)
		{
			if(source)
				_source = source;	
			else
				_source = new ObjectProxy({});
		}
	}
}