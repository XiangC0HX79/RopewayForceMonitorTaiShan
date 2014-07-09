package app.model.vo
{
	import flash.utils.Dictionary;

	use namespace InternalVO;
	
	internal class BracketThyVO extends BracketVO
	{
		public static const BRACKET_COUNT:int = 13;
		
		public static function facatoryCreateInstance(rw:RopewayVO):Dictionary
		{			
			var result:Dictionary = new Dictionary;
			
			for(var i:int = 0;i<BRACKET_COUNT;i++)
			{
				result[i] = new BracketThyVO(i,rw);
			}
			
			return result;
		}
		
		override public function get fullName():String
		{			
			if(bracketId == 0)
				return "驱动站支架";
			else if(bracketId == (BRACKET_COUNT - 1))
				return "回转站支架";
			else
				return bracketId.toString() + "#支架";
		}
		
		public function BracketThyVO(id:Number,rw:RopewayVO)
		{
			super(id, rw);
		}
	}
}