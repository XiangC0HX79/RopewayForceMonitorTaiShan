package app.model.vo
{
	[Bindable]
	public class RopewayStationFstVO extends RopewayStationVO
	{		
		public function RopewayStationFstVO(rw:RopewayVO)
		{
			super(rw);
		}
		
		override public function get station():String
		{
			return RopewayStationVO.FIRST;
		}
		
		override public function set station(value:String):void
		{
			super.station = value;
		}
		
	}
}