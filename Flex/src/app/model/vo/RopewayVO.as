package app.model.vo
{
	[Bindable]
	public class RopewayVO
	{
		public var ropewayId:String;
		
		public var ropewayRFId:String;
		
		//抱索力
		public var ropewayForce:Number;
		
		//温度
		public var ropewayTemp:Number;
		
		//时间
		public var ropewayTime:Date;
		
		//历史数据
		public var ropewayHistory:Array;
		
		public var todayMax:Number;		
		public var todayMin:Number;		
		public var todayAve:Number;		
		
		public var yesterdayMax:Number;		
		public var yesterdayMin:Number;		
		public var yesterdayAve:Number;		
		
		public function RopewayVO()
		{
			ropewayHistory = new Array;
		}
	}
}