package app.model.vo
{
	import flash.utils.Dictionary;

	use namespace InternalVO;
	
	internal class BracketZtmVO extends BracketVO
	{
		public static const BRACKET_COUNT:int = 16;
		
		public static function facatoryCreateInstance(rw:RopewayVO):Dictionary
		{			
			var result:Dictionary = new Dictionary;
			
			for(var i:int = 0;i<BRACKET_COUNT;i++)
			{
				result[i] = new BracketZtmVO(i,rw);
			}
			
			return result;
		}
		
		override public function get fullName():String
		{			
			switch(bracketId)
			{
				case 0:
					return "驱动站支架";
				case 8:
					return "8A#支架";
				case 9:
					return "8B#支架";
				case 10:
					return "9#支架";
				case 11:
					return "10#支架";
				case 12:
					return "11A#支架";
				case 13:
					return "11B#支架";
				case 14:
					return "11C#支架";
				case BRACKET_COUNT - 1:
					return "回转站支架";
				default:
					return bracketId.toString() + "#支架";
			}	
		}
		
		public function BracketZtmVO(id:Number,rw:RopewayVO)
		{
			super(id, rw);
		}
	}
}