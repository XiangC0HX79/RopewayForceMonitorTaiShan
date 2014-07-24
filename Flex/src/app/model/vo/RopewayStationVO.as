package app.model.vo
{
	import flash.errors.IllegalOperationError;
	
	import app.model.vo.InternalVO;
	
	use namespace InternalVO;
		
	[Bindable]
	public class RopewayStationVO
	{
		public static const FIRST:String = "驱动站";		
		public static const SECOND:String = "回转站";
		
		public static function newNull():RopewayStationVO
		{
			return new NullRopewayStation;
		}
				
		InternalVO static function getNamed(name:String):RopewayStationVO
		{
			var shortName:String = name.substr(0,3);
			var stationName:String = name.substr(3,3);
			
			var rw:RopewayVO = RopewayVO.getNamed(shortName + RopewayVO.SUFFIX_NAME);
			
			if(stationName == FIRST)
				return rw.stationFst;
			else if(stationName == SECOND)
				return rw.stationSnd;
			else
				return newNull();
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
			
		public function get station():String
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		public function set station(value:String):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

				
		private var _fullName:String;

		public function get fullName():String
		{
			return ropeway.shortName + station;
		}

		public function set fullName(value:String):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
				
		public var surrounding:SurroundingVO;
		
		/**
		 * 
		 * 构造函数
		 * 
		 */		
		public function RopewayStationVO(rw:RopewayVO)
		{
			_ropeway = rw;
			
			surrounding = new SurroundingVO;
		}
		
		/*private function store():void
		{
			_instance[fullName] = this;
		}*/
	}
}