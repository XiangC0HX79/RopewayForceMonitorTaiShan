package app.model.vo
{

	[Bindable]
	public class ForceVO
	{
		public var carriageId:String;
		
		public var ropewayStation:RopewayStationVO;
		
		public var value:Number = 0;
		
		public var unit:String;
		
		public var alarm:Number = 0;
		
		public var date:Date;
		
		public var switchFreqTotal:Number = 0;
		
		public var switchFreq:Number = 0;
		
		public function ForceVO(o:Object = null)
		{
			if(o)
			{
				this.carriageId = o.ropewayCarId;
				this.ropewayStation = new RopewayStationVO(o.ropewayStation);
				this.value = o.deteValue;
				this.unit = o.valueUnit;
				this.alarm = o.alarm;
				this.date = o.deteDate;
				this.switchFreqTotal = o.switchFreqTotal;
				this.switchFreq = o.switchFreq;
			}
		}
	}
}