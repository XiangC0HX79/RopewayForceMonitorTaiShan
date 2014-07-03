package app.model.vo
{
	import flash.errors.IllegalOperationError;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	import mx.utils.ObjectProxy;

	[Bindable]
	public class WindVO extends ObjectProxy
	{
		//public var bracket:BracketVO;
				
		public var history:ArrayCollection;
		
		//public var maxValue:Number;
		
		//public var minValue:Number;
		
		//public var firstValue:WindValueVO;
		
		public function get lastValue():WindValueVO
		{
			return (history && (history.length > 0))?history[history.length - 1]:new WindValueVO;
		}

		public function set lastValue(value:WindValueVO):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}

		
		public function WindVO()
		{
		}
		
		public function UnshiftWind(wv:WindValueVO):void
		{			
			history.source.unshift(wv);
		}
		
		public function PushWind(wv:WindValueVO):void
		{			
			history.source.push(wv);
			
			dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"lastValue",null,lastValue,this));
		}
	}
}