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
		
		//抱索力
		public var ropewayForce:Number;
		
		//单位
		public var ropewayUnit:String;
		
		//温度
		public var ropewayTemp:Number;
		
		//时间
		public var ropewayTime:Date;
		
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
		
		//历史数据
		public var ropewayHistory:Array;
		
		//开合次数
		public function get ropewayOpenCount():Number
		{
			return ropewayHistory.length;
		}
		public function set ropewayOpenCount(value:Number):void
		{
			
		}
				
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
		
		private var _source:ObjectProxy;
		
		public function RopewayVO(source:ObjectProxy = null)
		{						
			if(source)
				_source = source;
			else
				_source = new ObjectProxy;
		}
	}
}