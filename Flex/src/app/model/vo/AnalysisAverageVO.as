package app.model.vo
{
	[Bindable]
	public class AnalysisAverageVO extends AnalysisVO
	{				
		override public var deviceName:String;
		
		override public var ropewayName:String;
		
		public var date:String;
		
		public var aveValue:Number;		
		
		public var maxValue:Number;
		
		public var minValue:Number;
		
		public function AnalysisAverageVO(jd:*)
		{
			super(jd.DeviceID);
			
			maxValue = jd.MaxValue;
			minValue = jd.MinValue;
			aveValue = jd.AveValue;
			date = jd.DeteDate;
			deviceName = jd.DeviceName;
			ropewayName = jd.FromRopeWay;
		}
	}
}