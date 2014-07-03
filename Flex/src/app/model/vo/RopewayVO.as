package app.model.vo
{			
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	import mx.utils.ObjectProxy;
	
	use namespace InternalVO;
	
	[Bindable]
	public class RopewayVO extends ObjectProxy
	{		
		public static const SUFFIX_NAME:String 			="索道";
		
		public static const ZHONG_TIAN_MEN:String 		= "中天门索道";		
		public static const TAO_HUA_YUAN:String 		= "桃花源索道";
		
		public static function newNull():RopewayVO
		{
			return new NullRopeway;
		}
				
		private static var _instance:Dictionary;
				
		InternalVO static function loadRopeway():void
		{
			_instance = new Dictionary;
			
			new RopewayVO(ZHONG_TIAN_MEN).store();
			new RopewayVO(TAO_HUA_YUAN).store();
		}
		
		InternalVO static function get list():Array
		{			
			var result:Array = [];
			for each(var rw:RopewayVO in _instance)
			{
				result.push(rw);
			}
			result.sortOn("id",Array.NUMERIC);
			return result;			
		}
		
		InternalVO static function getNamed(name:String):RopewayVO
		{
			switch(name)
			{
				case ZHONG_TIAN_MEN:
				case TAO_HUA_YUAN:
					return _instance[name];
				default:
					return newNull();					
			}
		}
		 
		public function get id():int
		{
			switch(fullName)
			{
				case ZHONG_TIAN_MEN:
					return 2;
				case TAO_HUA_YUAN:
					return 3;
				default:
					throw(new IllegalOperationError("非法站点类型：" + fullName));					
			}
		}

		public function set id(value:int):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function get shortName():String
		{
			return fullName.substr(0,fullName.length - 2);
		}
		
		public function set shortName(value:String):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
				
		private var _fullName:String;

		public function get fullName():String
		{
			return _fullName;
		}

		public function set fullName(value:String):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public var stationFst:RopewayStationFstVO;
		
		public var stationSnd:RopewayStationSndVO;
		
		public var engineFst:EngineFstVO;
		
		public var engineSnd:EngineSndVO;
		
		private var _instanceBracket:Dictionary;
		
		public function get listBracket():ArrayCollection
		{
			var array:Array = [];
			for each(var bracket:BracketVO in _instanceBracket)
			{
				array.push(bracket);
			}
			array.sortOn("bracketId",Array.NUMERIC);
			
			return new ArrayCollection(array);
		}

		public function set listBracket(value:ArrayCollection):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		
		public var inch:InchVO;
						
		/**
		 * 
		 * 构造函数
		 * 
		 */		
		public function RopewayVO(value:String)
		{
			_fullName = value;
			
			stationFst = new RopewayStationFstVO(this);
			
			stationSnd = new RopewayStationSndVO(this);
			
			engineFst = new EngineFstVO(this);
			
			engineSnd = new EngineSndVO(this);
			
			inch = new InchVO(this);
			
			_instanceBracket = new Dictionary;
		}
		
		private function store():void
		{
			_instance[fullName] = this;
		}
		
		public function getBracket(bracketId:int):BracketVO
		{			
			if(!_instanceBracket[bracketId])
			{
				_instanceBracket[bracketId] = new BracketVO(bracketId,this);		
				
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"listBracket",null,listBracket,this));
			}
			
			return _instanceBracket[bracketId];
		}
	}
}