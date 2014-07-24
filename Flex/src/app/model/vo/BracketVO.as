package app.model.vo
{
	import com.adobe.utils.DateUtil;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;

	use namespace InternalVO;
	
	[Bindable]
	public class BracketVO extends DeviceVO
	{		
		public static function facatoryCreateInstance(rw:RopewayVO):Dictionary
		{			
			if(rw.fullName == RopewayVO.ZHONG_TIAN_MEN)
				return BracketZtmVO.facatoryCreateInstance(rw);
			else if(rw.fullName == RopewayVO.TAO_HUA_YUAN)
				return BracketThyVO.facatoryCreateInstance(rw);
			else
				return NullBracket.facatoryCreateInstance();
		}
		
		public static function newAll(rw:RopewayVO):BracketVO
		{
			return new AllBracketVO(rw);
		}
		
		public static function newNull():BracketVO
		{
			return new NullBracket;
		}
		
		InternalVO static function getName(rwName:String,id:int):BracketVO
		{
			return RopewayVO.getNamed(rwName).getBracket(id);
		}
		
		public var bracketId:int;
				
		override public function get deviceId():int
		{
			return bracketId;
		}
		
		override public function set deviceId(value:int):void
		{
			//_deviceId = value;
		}
		
		public function get fullName():String
		{			
			throw(new IllegalOperationError("调用抽象方法"));
		}

		public function set fullName(value:String):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		private var _history:ArrayCollection;
		
		public function get hasHistory():Boolean
		{
			return  (_history != null);
		}
				
		public function newHistory():void
		{
			_history = new ArrayCollection;
			
			ropeway.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"listBracket",null,ropeway.listBracket));	
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
				
		public function get lastValue():WindValueVO
		{
			return (_history && (_history.length > 0))?_history[_history.length - 1]:new WindValueVO;
		}
		
		public function set lastValue(value:WindValueVO):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function get lastHour():ArrayCollection
		{
			var now:Date = DateUtil.addDateTime('h',-1,new Date);
			
			var result:Array = [];
			for(var i:int = _history.length - 1; i>=0;i--)
			{
				var item:WindValueVO =  _history[i];
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
		
		public function BracketVO(id:Number,rw:RopewayVO)
		{
			super(rw);
			
			bracketId = id;
		}
		
		public function PushWind(wv:WindValueVO,willTriggerEvent:Boolean = true):void
		{			
			_history.source.push(wv);
			
			if(willTriggerEvent)
			{
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"lastValue",null,lastValue,this));
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"maxValue",null,maxValue,this));
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"minValue",null,minValue,this));
				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"lastHour",null,lastHour,this));		
				
				ropeway.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.UPDATE,"maxBracket",null,ropeway.maxBracket));
			}
		}
	}
}