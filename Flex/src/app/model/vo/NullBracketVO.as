package app.model.vo
{
	internal class NullBracketVO extends BracketVO
	{
		public function NullBracketVO()
		{
			super(-1, RopewayVO.newNull());
		}
	}
}