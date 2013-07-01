package app.model.vo
{
	[Bindable]
	public class RopewayVO
	{
		public var ropewayId:String;
		
		public var ropewayRFId:String;
		
		//抱索力
		public var ropewayForce:Number;
		
		//单位
		public var ropewayUnit:String;
		
		//温度
		public var ropewayTemp:Number;
		
		//时间
		public var ropewayTime:Date;
		
		//历史数据
		public var ropewayHistory:Array;
		
		public var todayMax:Number;		
		public var todayMin:Number;		
		public var todayAve:Number;		
		
		public function get yesterdayMax():Number	
		{
			return todayMax;
		}
		public function set yesterdayMax(value:Number):void	
		{
		}
		
		public function get yesterdayMin():Number	
		{
			return todayMin;
		}
		public function set yesterdayMin(value:Number):void	
		{
		}
		
		public function get yesterdayAve():Number	
		{
			return todayAve;
		}
		public function set yesterdayAve(value:Number):void	
		{
		}
		
		public function RopewayVO()
		{
			ropewayHistory = new Array;
		}
	}
}