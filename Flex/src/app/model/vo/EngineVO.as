package app.model.vo
{	
	import flash.errors.IllegalOperationError;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	import mx.utils.ObjectProxy;
	
	use namespace InternalVO;
	
	[Bindable]
	public class EngineVO extends ObjectProxy
	{
		public static const FIRST:int = 0;
		public static const SECOND:int = 1;
		
		/*private static var _instance:Dictionary = new Dictionary;
				
		public static function loadEngine(listRw:ArrayCollection):Array
		{
			for each(var rw:RopewayVO in listRw)
			{
				new EngineVO(rw,EngineVO.FIRST).store();
				new EngineVO(rw,EngineVO.SECOND).store();
			}
			
			var result:Array = [];
			for each(var engine:EngineVO in _instance)
			{
				result.push(engine);
			}
			return result;			
		}
		
		InternalVO static function getHashCode(rwName:String,p:int):String
		{
			return rwName + p;
		}*/
				
		InternalVO static function getNamed(rwName:String,p:int):EngineVO
		{
			var rw:RopewayVO = RopewayVO.getNamed(rwName);
			
			if(p == FIRST)
				return rw.engineFst;
			else if(p == SECOND)
				return rw.engineSnd;
			else
				throw(new IllegalOperationError("调用抽象方法"));
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
		
		public function get pos():int
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		public function set pos(value:int):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function get firstTemp():EngineTempVO
		{
			return (history.length > 0)?history[0]:null;
		}

		public function set firstTemp(value:EngineTempVO):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		//public var lastTemp:EngineTempVO;
		public function get lastTemp():EngineTempVO
		{
			return (history.length > 0)?history[history.length - 1]:new EngineTempVO;
		}

		public function set lastTemp(value:EngineTempVO):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function get maxTemp():Number
		{
			if(history.source.length == 0)
				return 0;
			
			var array:Array = [];
			array = array.concat(history.source);
			array.sortOn("temp",Array.NUMERIC);
			return EngineTempVO(array[array.length - 1]).temp;
		}

		public function set maxTemp(value:Number):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		public function get minTemp():Number
		{
			if(history.source.length == 0)
				return 0;
			
			var array:Array = [];
			array = array.concat(history.source);
			array.sortOn("temp",Array.NUMERIC);
			return EngineTempVO(array[0]).temp;
		}

		public function set minTemp(value:Number):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		public function get aveTemp():Number
		{
			if(history.source.length == 0)
				return 0;
			
			var total:Number = 0;
			for each(var et:EngineTempVO in history)
				total += et.temp;
				
			return Math.round(total / history.length * 10) / 10;
		}

		public function set aveTemp(value:Number):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		//public var date:Date;
		
		public var history:ArrayCollection;
		
		public function EngineVO(rw:RopewayVO)
		{
			_ropeway = rw;
			
			history = new ArrayCollection;
			
			//lastTemp = new EngineTempVO;
		}
		
		/*public function store():void
		{
			_instance[getHashCode(ropeway.fullName,pos)] = this;
		}
		
		public function UnshiftItem(et:EngineTempVO):void
		{			
			history.source.unshift(et);
		}*/
		
		public function PushItem(et:EngineTempVO):void
		{			
			history.source.push(et);
			
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"lastTemp",null,lastTemp));
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"maxTemp",null,maxTemp));
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"aveTemp",null,aveTemp));
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"minTemp",null,minTemp));
		}
	}
}