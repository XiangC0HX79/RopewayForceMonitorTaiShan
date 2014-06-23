package app.model.vo
{
	[Bindable]
	public class SurroundingTempVO
	{
		public var ropewayStation:RopewayStationVO;
		
		public var date:Date;
		
		public var temp:Number = 0;
		
		public var humi:Number = 0;
		
		public function SurroundingTempVO()
		{
		}
	}
}