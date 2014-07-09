package app.model.vo
{
	import flash.errors.IllegalOperationError;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	import mx.utils.ObjectProxy;

	[Bindable]
	public class WindVO extends ObjectProxy
	{
		private var _bracket:BracketVO;
				
		private var _history:ArrayCollection;
		
		public function get hasHistory():Boolean
		{
			return  (_history != null);
		}
		
		public function newHistory():void
		{
			_history = new ArrayCollection;
			
			BindingUtils.bindSetter(setterWindLastValue,this,"lastValue");
			
			_bracket.ropeway.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"listBracket",null,_bracket.ropeway.listBracket));	
		}
				
		private function setterWindLastValue(obj:Object):void
		{			
			_bracket.ropeway.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"maxBracket",null,_bracket.ropeway.maxBracket));		
		}
		
		public function get maxValue():Number
		{
			if(_history.source.length == 0)
				return 0;
			
			var array:Array = [];
			array = array.concat(_history.source);
			array.sortOn("speed",Array.NUMERIC);
			
			return WindValueVO(array[array.length - 1]).speed;
		}

		public function set maxValue(value:Number):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function get minValue():Number
		{
			if(_history.source.length == 0)
				return 0;
			
			var array:Array = [];
			array = array.concat(_history.source);
			array.sortOn("speed",Array.NUMERIC);
			
			return WindValueVO(array[0]).speed;
		}

		public function set minValue(value:Number):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		
		//public var firstValue:WindValueVO;
		
		public function get lastValue():WindValueVO
		{
			return (_history && (_history.length > 0))?_history[_history.length - 1]:new WindValueVO;
		}

		public function set lastValue(value:WindValueVO):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		
		public function WindVO(bracket:BracketVO)
		{
			_bracket = bracket;
		}
		
		public function UnshiftWind(wv:WindValueVO):void
		{			
			_history.source.unshift(wv);
		}
		
		public function PushWind(wv:WindValueVO):void
		{			
			_history.source.push(wv);
			
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"lastValue",null,lastValue,this));
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"maxValue",null,maxValue,this));
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"minValue",null,minValue,this));
		}
	}
}