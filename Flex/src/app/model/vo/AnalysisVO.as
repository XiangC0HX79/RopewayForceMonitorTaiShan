package app.model.vo
{
	import flash.errors.IllegalOperationError;

	public class AnalysisVO
	{
		private var _device:DeviceVO;
		
		public function get deviceName():String
		{
			return _device.deviceName;
		}
		
		public function set deviceName(value:String):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function get ropewayName():String
		{
			return _device.ropeway.fullName;
		}
		
		public function set ropewayName(value:String):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function AnalysisVO(deviceId:int)
		{			
			_device = DeviceVO.getNamed(deviceId);
		}
	}
}