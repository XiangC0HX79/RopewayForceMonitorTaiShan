package app.model.vo
{
	[Bindable]
	public class RopewayStationSndVO extends RopewayStationVO
	{		
		public function RopewayStationSndVO(rw:RopewayVO)
		{
			super(rw);
		}
		
		override public function get station():String
		{
			return RopewayStationVO.SECOND;
		}
		
		override public function set station(value:String):void
		{
			super.station = value;
		}
		
	}
}