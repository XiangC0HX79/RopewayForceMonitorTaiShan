package app.model.vo
{	
	import flash.errors.IllegalOperationError;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	use namespace InternalVO;
	
	[Bindable]
	public class EngineVO extends DeviceVO
	{
		public static const FIRST:int = 0;
		public static const SECOND:int = 1;
						
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
				
		override public function get deviceId():int
		{
			return pos;
		}
		
		override public function set deviceId(value:int):void
		{
			//_deviceId = value;
		}
		
		public function get pos():int
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		public function set pos(value:int):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
				
		public function get fullName():String
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function set fullName(value:String):void
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
		
		public var history:ArrayCollection;
		
		public function EngineVO(rw:RopewayVO)
		{
			super(rw);
			
			history = new ArrayCollection;
		}
		
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