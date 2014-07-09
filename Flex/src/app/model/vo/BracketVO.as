package app.model.vo
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;

	use namespace InternalVO;
	
	[Bindable]
	public class BracketVO
	{		
		public static function facatoryCreateInstance(rw:RopewayVO):Dictionary
		{			
			if(rw.fullName == RopewayVO.ZHONG_TIAN_MEN)
				return BracketZtmVO.facatoryCreateInstance(rw);
			else if(rw.fullName == RopewayVO.TAO_HUA_YUAN)
				return BracketThyVO.facatoryCreateInstance(rw);
			else
				return NullBracketVO.facatoryCreateInstance();
		}
		
		public static function newAll(rw:RopewayVO):BracketVO
		{
			return new AllBracketVO(rw);
		}
		
		public static function newNull():BracketVO
		{
			return new NullBracketVO;
		}
		
		InternalVO static function getName(rwName:String,id:int):BracketVO
		{
			return RopewayVO.getNamed(rwName).getBracket(id);
		}
		
		public var bracketId:int;
		
		public var ropeway:RopewayVO;
		
		public var wind:WindVO;
				
		public function get fullName():String
		{			
			throw(new IllegalOperationError("调用抽象方法"));
		}

		public function set fullName(value:String):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function BracketVO(id:Number,rw:RopewayVO)
		{
			bracketId = id;
			
			ropeway = rw;
			
			wind = new WindVO(this);
		}
	}
}