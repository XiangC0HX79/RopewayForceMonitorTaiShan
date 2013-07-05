package app.model.vo
{
	import mx.utils.ObjectProxy;

	[Bindable]
	public class RopewayVO
	{
		/**
		 * 抱索器编号
		 * */
		public function get ropewayId():String
		{
			return _source.RopeCode;
		}
		public function set ropewayId(value:String):void
		{
		}
		
		/**
		 * RFID编号
		 * */
		public function get ropewayRFId():String
		{
			return _source.RFIDCode;
		}
		public function set ropewayRFId(value:String):void
		{
		}
		
		/**
		 * 车厢编号
		 * */
		public function get ropewayCarId():String
		{
			return _source.CarriageCode;
		}
		public function set ropewayCarId(value:String):void
		{
		}
		
		/**
		 * RFID电量
		 * */
		public function get ropewayRFIDEletric():Boolean
		{
			return (_source.RFIDDL != "1");
		}
		public function set ropewayRFIDEletric(value:Boolean):void
		{
		}
				
		/**
		 * 所属索道
		 **/
		public function get ropeway():String
		{
			return _source.FromRopeWay;
		}
		public function set ropeway(value:String):void
		{
		}
		
		/**
		 * 是否使用
		 **/
		public function get isUse():Boolean
		{
			return (_source.IsUse != "1");
		}
		public function set isUse(value:Boolean):void
		{
		}
		
		/**
		 * 最后编辑日期
		 **/
		public function get lastUpdateTime():Date
		{
			return _source.lastUpdateDatetime;
		}
		public function set lastUpdateTime(value:Date):void
		{
		}
				
		/**
		 * 最后编辑人
		 **/
		public function get lastUpdateUser():Date
		{
			return _source.lastUpdateUser;
		}
		public function set lastUpdateUser(value:Date):void
		{
		}
				
		/**
		 * 最新抱索力
		 **/
		public function get ropewayForce():RopewayForceVO	
		{
			return (ropewayHistory.length > 0)?ropewayHistory[ropewayHistory.length - 1]:null;
		}
		public function set ropewayUnit(value:String):void	
		{
		}
		
		//抱索力
		//public var ropewayForce:Number;
		
		//单位
		//public var ropewayUnit:String;
		
		//温度
		//public var ropewayTemp:Number;
		
		//时间
		//public var ropewayTime:Date;
		
		//开合次数
		public function get ropewayOpenCount():Number
		{
			return ropewayHistory.length;
		}
		public function set ropewayOpenCount(value:Number):void
		{
			
		}
		
		/**
		 * 今日最大值
		 **/
		public function get todayMax():Number	
		{			
			var n:Number = 0;
			for each(var rf:RopewayForceVO in ropewayHistory)
			{
				if(n < rf.ropewayForce)
					n = rf.ropewayForce;
			}
			return n;
		}
		public function set todayMax(value:Number):void	
		{
		}
		
		/**
		 * 今日最小值
		 **/
		public function get todayMin():Number	
		{			
			var n:Number = Number.MAX_VALUE;
			for each(var rf:RopewayForceVO in ropewayHistory)
			{
				if(n > rf.ropewayForce)
					n = rf.ropewayForce;
			}
			return n;
		}
		public function set todayMin(value:Number):void	
		{
		}
		
		/**
		 * 今日平均值
		 **/
		public function get todayAve():Number	
		{			
			var n:Number = 0;
			for each(var rf:RopewayForceVO in ropewayHistory)
			{
				n += rf.ropewayForce;
			}
			
			n = Math.round(n / ropewayHistory.length);
			
			return n;
		}
		public function set todayAve(value:Number):void	
		{
		}
				
		/**
		 * 昨日最大值
		 **/
		public function get yesterdayMax():Number	
		{
			return _source.MaxValue;
		}
		public function set yesterdayMax(value:Number):void	
		{
		}
		
		/**
		 * 昨日最小值
		 **/
		public function get yesterdayMin():Number	
		{
			return _source.MinValue;
		}
		public function set yesterdayMin(value:Number):void	
		{
		}
		
		/**
		 * 昨日平均值
		 **/
		public function get yesterdayAve():Number	
		{
			return _source.AverageValue;
		}
		public function set yesterdayAve(value:Number):void	
		{
		}
				
		/**
		 * 抱索力列表
		 **/
		public var ropewayHistory:Array = new Array;
		
		private var _source:ObjectProxy;
		
		public function RopewayVO(source:ObjectProxy)
		{					
			_source = source;
		}
	}
}