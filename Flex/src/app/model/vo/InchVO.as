package app.model.vo
{
	import com.adobe.utils.DateUtil;
	
	import flash.errors.IllegalOperationError;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	use namespace InternalVO;

	[Bindable]
	public class InchVO extends DeviceVO
	{
		InternalVO static function getNamed(rwName:String):InchVO
		{
			return RopewayVO.getNamed(rwName).inch;
		}
		
		private var _aveDay:Number = 0;

		public function get aveDay():Number
		{
			if(his.source.length == 0)
				return 0;
			
			var total:Number = 0;
			for each(var et:InchValueVO in his)
				total += et.value;
			
			return Math.round(total / his.length * 100) / 100;
		}

		public function set aveDay(value:Number):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		public var aveMon:Number = 0;
		public var aveThreeMon:Number = 0;
		
		public var periodAveDay:Number = 0;
		public var periodAveMon:Number = 0;
		public var periodThreeMon:Number = 0;
		
		private var _maxValue:Number;

		public function get maxValue():Number
		{
			if(his.source.length == 0)
				return 0;
			
			var array:Array = [];
			array = array.concat(his.source);
			array.sortOn("value",Array.NUMERIC);
			return InchValueVO(array[array.length - 1]).value;
		}

		public function set maxValue(value:Number):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		
		private var _minValue:Number;

		public function get minValue():Number
		{
			if(his.source.length == 0)
				return 0;
			
			var array:Array = [];
			array = array.concat(his.source);
			array.sortOn("value",Array.NUMERIC);
			return InchValueVO(array[0]).value;
		}

		public function set minValue(value:Number):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		private var _firstValue:InchValueVO;

		public function get firstValue():InchValueVO
		{
			return (his.length > 0)?his[0]:null;
		}

		public function set firstValue(value:InchValueVO):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		
		public function get lastValue():InchValueVO
		{
			return (his.length > 0)?his[his.length - 1]:new InchValueVO;
		}

		public function set lastValue(value:InchValueVO):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public var his:ArrayCollection;
		
		public function InchVO(rw:RopewayVO)
		{
			super(rw);
			
			his = new ArrayCollection;
		}
		
		public function PushItem(inch:InchValueVO,willTriggerEvent:Boolean = true):void
		{			
			his.source.push(inch);
			
			if(willTriggerEvent)
			{
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"lastValue",null,lastValue));
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"aveDay",null,aveDay));
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"minValue",null,minValue));
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"maxValue",null,maxValue));
			}
		}
	}
}