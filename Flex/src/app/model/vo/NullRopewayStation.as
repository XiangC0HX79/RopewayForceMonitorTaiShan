package app.model.vo
{	
	internal class NullRopewayStation extends RopewayStationVO
	{		
		public static const STATION:String = "Station";
				
		override public function get station():String
		{
			return STATION;
		}
		
		public function NullRopewayStation()
		{
			super(RopewayVO.newNull());
		}
	}
}