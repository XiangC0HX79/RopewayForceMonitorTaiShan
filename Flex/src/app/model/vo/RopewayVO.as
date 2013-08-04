package app.model.vo
{
	import mx.utils.ObjectProxy;

	[Bindable]
	public class RopewayVO
	{
		public static const ALL:RopewayVO = new RopewayVO(new ObjectProxy({RopeCode:"所有抱索器",CarriageCode:"所有吊箱"}));
		
		/**
		 * 抱索器编号
		 * */
		public function get ropewayId():String
		{
			return _source.RopeCode;
		}
		public function set ropewayId(value:String):void
		{
			_source.RopeCode = value;
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
			_source.CarriageCode = value;
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
			_source.RFIDDL = value?"0":"1";
		}
		
		/**
		 * 所属索道站
		 **/
		public function get ropewayStation():String
		{
			return _source.FromRopeStation;
		}
		public function set ropewayStation(value:String):void
		{
			_source.FromRopeStation = value;
		}
		
		/**
		 * 所属索道
		 **/
		public function get fromRopeWay():String
		{
			return _source.FromRopeWay;
		}
		public function set fromRopeWay(value:String):void
		{
			_source.FromRopeWay = value;
		}
		
		/**
		 * 当前抱索力
		 * */
		public function get deteValue():Number
		{
			return _source.DeteValue;
		}
		public function set deteValue(value:Number):void
		{
			_source.DeteValue = value;
		}
		
		/**
		 * 当前单位
		 * */
		public function get valueUnit():String
		{
			return _source.ValueUnit;
		}
		public function set valueUnit(value:String):void
		{
			_source.ValueUnit = value;
		}
		
		/**
		 * 当前温度
		 * */
		public function get temperature():Number
		{
			return _source.Temperature;
		}
		public function set temperature(value:Number):void
		{
			_source.Temperature = value;
		}
		
		/**
		 * 当前湿度
		 * */
		public function get humidity():Number
		{
			return _source.Humidity;
		}
		public function set humidity(value:Number):void
		{
			_source.Humidity = value;
		}
		
		/**
		 * 报警类型
		 * 0-正常
		 * 1-平均值报警
		 * 2-单次值报警
		 * */
		public var alarm:Number;
		
		/**
		 * 监测时间
		 * */
		public function get deteDate():Date
		{
			return _source.DeteDate;
		}
		public function set deteDate(value:Date):void
		{
			_source.DeteDate = value;
		}
		
		/**
		 * 开合总数
		 * */
		public function get switchFreqTotal():Number
		{
			return isNaN(_source.SwitchFreqTotal)?0:_source.SwitchFreqTotal;
		}
		public function set switchFreqTotal(value:Number):void
		{
			_source.SwitchFreqTotal = value;
		}
		
		/**
		 * 开合次数
		 **/
		public function get switchFreq():Number
		{
			return _source.SwitchFreq;
		}
		public function set switchFreq(value:Number):void
		{
			_source.SwitchFreq = value;
		}
		
		/**
		 * 今日最大值
		 **/
		public function get maxValue():Number
		{
			return _source.MaxValue;
		}
		public function set maxValue(value:Number):void
		{
			_source.MaxValue = value;
		}
		
		/**
		 * 今日最小值
		 **/
		public function get minValue():Number
		{
			return _source.MinValue;
		}
		public function set minValue(value:Number):void
		{
			_source.MinValue = value;
		}
		
		/**
		 * 今日合计值
		 **/
		public function get totalValue():Number
		{
			return _source.TotalValue;
		}
		public function set totalValue(value:Number):void
		{
			_source.TotalValue = value;
		}
		
		/**
		 * 今日平均值
		 **/
		public function get aveValue():Number	
		{			
			return _source.AveValue;
		}
		public function set aveValue(value:Number):void	
		{
			_source.AveValue = value;
		}
		
		/**
		 * 平均值记录时间
		 **/
		public function get yesterdayDate():Date	
		{
			return _source.RecordDate;
		}
		public function set yesterdayDate(value:Date):void	
		{
		}
		
		/**
		 * 昨日最大值
		 **/
		public function get yesterdayMax():Number	
		{
			return _source.MaxValueY;
		}
		public function set yesterdayMax(value:Number):void	
		{
		}
		
		/**
		 * 昨日最小值
		 **/
		public function get yesterdayMin():Number	
		{
			return _source.MinValueY;
		}
		public function set yesterdayMin(value:Number):void	
		{
		}
		
		/**
		 * 昨日平均值
		 **/
		public function get yesterdayAve():Number	
		{
			return _source.AverageValueY;
		}
		public function set yesterdayAve(value:Number):void	
		{
		}
				
		/**
		 * 抱索力列表
		 **/
		public var ropewayHistory:Array;
		
		private var _source:ObjectProxy;
		
		public function RopewayVO(source:ObjectProxy)
		{					
			_source = source;
		}
	}
}