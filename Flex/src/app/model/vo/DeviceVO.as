package app.model.vo
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import mx.utils.ObjectProxy;

	public class DeviceVO extends ObjectProxy
	{
		private static var _instance:Dictionary = new Dictionary;
		
		internal static function getNamed(deviceId:int):DeviceVO
		{
			return _instance[deviceId]?_instance[deviceId]:newNull();
		}
		
		internal static function newNull():DeviceVO
		{
			return new NullDevice;
		}
		
		private var _ropeway:RopewayVO;

		public function get ropeway():RopewayVO
		{
			return _ropeway;
		}

		public function set ropeway(value:RopewayVO):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		private var _deviceId:int;

		public function get deviceId():int
		{
			return _deviceId;
		}

		public function set deviceId(value:int):void
		{
			_deviceId = value;
		}
		
		public var deviceName:String;
		
		public function DeviceVO(rw:RopewayVO)
		{
			_ropeway = rw;
		}
		
		protected function store():void
		{
			_instance[deviceId] = this;
		}
	}
}