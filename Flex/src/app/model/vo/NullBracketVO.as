package app.model.vo
{
	import flash.utils.Dictionary;

	internal class NullBracketVO extends BracketVO
	{
		public static function facatoryCreateInstance():Dictionary
		{			
			return new Dictionary;
		}
		
		override public function get fullName():String
		{
			return "";
		}
		
		public function NullBracketVO()
		{
			super(-1, RopewayVO.newNull());
		}
	}
}