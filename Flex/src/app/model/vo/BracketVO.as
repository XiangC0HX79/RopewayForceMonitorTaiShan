package app.model.vo
{
	import flash.errors.IllegalOperationError;
	
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;

	use namespace InternalVO;
	
	[Bindable]
	public class BracketVO
	{
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
			var _fullName:String;
			
			if(ropeway.shortName == "中天门")
			{										
				switch(bracketId)
				{
					case 0:
						_fullName = "驱动站支架";
						break;
					case 8:
						_fullName = "8A#支架";
						break;
					case 9:
						_fullName = "8B#支架";
						break;
					case 10:
						_fullName = "9#支架";
						break;
					case 11:
						_fullName = "10#支架";
						break;
					case 12:
						_fullName = "11A#支架";
						break;
					case 13:
						_fullName = "11B#支架";
						break;
					case 14:
						_fullName = "11C#支架";
						break;
					case 15:
						_fullName = "回转站支架";
						break;
					default:
						_fullName = bracketId.toString() + "#支架";
				}	
			}
			else if(ropeway.shortName == "桃花源")
			{
				if(bracketId == 0)
					_fullName = "驱动站支架";
				else if(bracketId == 12)
					_fullName = "回转站支架";
				else
					_fullName = bracketId.toString() + "#支架";
			}
						
			return _fullName;
		}

		public function set fullName(value:String):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function BracketVO(id:Number,rw:RopewayVO)
		{
			bracketId = id;
			
			ropeway = rw;
			
			wind = new WindVO;
		}
	}
}