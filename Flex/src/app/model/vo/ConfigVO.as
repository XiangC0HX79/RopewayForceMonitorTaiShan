package app.model.vo
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import app.model.dict.RopewayDict;

	[Bindable]
	public class ConfigVO
	{
		public var user:String;
				
		public var station:String;
		
		private var _ropeway:RopewayDict;
		public function get ropeway():RopewayDict
		{
			return _ropeway;
		}
		public function set ropeway(value:*):void
		{
			_ropeway = value as RopewayDict;
		}
		
		public var stations:ArrayCollection;
		
		public var serverIp:String;
		
		public var serverPort:int;
		
		public var pin:Boolean = false;
		
		//public static var debug:Boolean = true;
	}
}