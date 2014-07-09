package app.model.vo
{
	internal class AllBracketVO extends BracketVO
	{		
		public function AllBracketVO(rw:RopewayVO)
		{
			super(-1, rw);
		}
		
		override public function get fullName():String
		{
			return "所有支架";
		}
		
	}
}