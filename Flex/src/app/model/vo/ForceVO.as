package app.model.vo
{
    use namespace InternalVO;
	
	[Bindable]
	public class ForceVO
	{		
		InternalVO static function getNamed(rsName:String):ForceVO
		{
			return RopewayStationVO.getNamed(rsName).force;
		}
		
		public var carriageId:String;
		
		public var rsName:String;
		
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
				this.rsName = o.ropewayStation;
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