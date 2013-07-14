package app.model.vo
{
	import mx.utils.ObjectProxy;

	[Bindable]
	public class RopewayForceAverageVO
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
			_source.RopeCode = value;
		}
		
		/**
		 * 吊箱编号
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
		 * 时间
		 **/
		public function get ropewayTime():Date	
		{
			return _source.RecordDate;
		}
		public function set ropewayTime(value:Date):void	
		{
			_source.RecordDate = value;
		}
		
		/**
		 * 平均值
		 **/
		public function get averageValue():Number	
		{
			return _source.AverageValue;
		}
		public function set averageValue(value:Number):void	
		{
			_source.AverageValue = value;
		}
		
		/**
		 * 最小值
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
		 * 最大值
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
		 * 所属索道站
		 **/
		public function get fromRopeStation():String	
		{
			return _source.FromRopeStation;
		}
		public function set fromRopeStation(value:String):void	
		{
			_source.FromRopeStation = value;
		}
		
		private var _source:ObjectProxy;
		
		public function RopewayForceAverageVO(source:ObjectProxy)
		{
			_source = source;			
		}
	}
}