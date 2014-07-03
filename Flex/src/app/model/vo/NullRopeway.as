package app.model.vo
{
	internal class NullRopeway extends RopewayVO
	{
		private static const NAME:String = "未知索道";
		
		override public function get id():int
		{
			return 0;
		}
		
		public function NullRopeway()
		{
			super(NAME);
		}
	}
}