package app.model.vo
{
	import com.adobe.utils.DateUtil;
	
	import flash.errors.IllegalOperationError;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	use namespace InternalVO;

	[Bindable]
	public class PressVO extends DeviceVO
	{
		InternalVO static function getNamed(rwName:String):PressVO
		{
			return RopewayVO.getNamed(rwName).press;
		}
		
		public var history:ArrayCollection;
				
		public function get lastValue():PressValueVO
		{
			return (history.length > 0)?history[history.length - 1]:new PressValueVO;
		}
		
		public function set lastValue(value:PressValueVO):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
				
		public function get lastHour():ArrayCollection
		{
			var now:Date = DateUtil.addDateTime('h',-1,new Date);
			
			var result:Array = [];
			for(var i:int = history.length - 1; i>=0;i--)
			{
				var item:PressValueVO =  history[i];
				if(item.date.time > now.time)
				{
					result.unshift(item);
				}
			}
			return new ArrayCollection(result);
		}
		
		public function set lastHour(value:ArrayCollection):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function PressVO(rw:RopewayVO)
		{
			super(rw);
			
			history = new ArrayCollection;
		}
		
		public function PushItem(press:PressValueVO,willTriggerEvent:Boolean = true):void
		{			
			history.source.push(press);
			
			if(willTriggerEvent)
			{
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"lastValue",null,lastValue));
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"lastHour",null,lastHour));
			}
		}
	}
}