package app.model.vo
{
	import flash.utils.Dictionary;

	internal class NullBracket extends BracketVO
	{
		public static function facatoryCreateInstance():Dictionary
		{			
			return new Dictionary;
		}
		
		override public function get fullName():String
		{
			return "";
		}
		
		public function NullBracket()
		{
			super(-1, RopewayVO.newNull());
		}
	}
}