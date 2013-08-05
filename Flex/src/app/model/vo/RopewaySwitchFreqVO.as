package app.model.vo
{
	import com.adobe.serialization.json.JSON;
	
	import mx.utils.ObjectProxy;

	[Bindable]
	public class RopewaySwitchFreqVO
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
		public function get ropewayTime():String	
		{
			return _source.RecordDate;
		}
		public function set ropewayTime(value:String):void	
		{
			_source.RecordDate = value;
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
		
		private var _source:ObjectProxy;
		
		public function RopewaySwitchFreqVO(source:ObjectProxy)
		{
			_source = source;			
		}
		
		public function toString():String
		{
			return JSON.encode(_source.valueOf());
		}
	}
}