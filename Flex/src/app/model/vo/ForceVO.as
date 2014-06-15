package app.model.vo
{	
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.DateUtil;
	
	import mx.utils.ObjectProxy;
	import mx.utils.object_proxy;

	[Bindable]
	public class ForceVO
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
		 * 抱索力
		 **/
		public function get ropewayForce():Number	
		{
			return _source.DeteValue;
		}
		public function set ropewayForce(value:Number):void	
		{
			_source.DeteValue = value;
		}
		
		/**
		 * 抱索力单位
		 **/
		public function get ropewayUnit():String	
		{
			return _source.ValueUnit;
		}
		public function set ropewayUnit(value:String):void	
		{
			_source.ValueUnit = value;
		}
		
		/**
		 * 温度
		 **/
		public function get ropewayTemp():Number	
		{
			return _source.Temperature;
		}
		public function set ropewayTemp(value:Number):void	
		{
			_source.Temperature = value;
		}
		
		/**
		 * 湿度
		 **/
		public function get ropewayHumidity():Number	
		{
			return _source.Humidity;
		}
		public function set ropewayHumidity(value:Number):void	
		{
			_source.Humidity = value;
		}
		
		/**
		 * 电量
		 **/
		/*public function get eletric():Boolean
		{
			return (_source.DL == 0);
		}
		public function set eletric(value:Boolean):void	
		{
			_source.DL = value?0:1;
		}*/
		
		/**
		 * 时间
		 **/
		public function get ropewayTime():Date	
		{
			if(_source.DeteDate is Date)				
				return _source.DeteDate;
			else
				return new Date(Date.parse(_source.DeteDate));
		}
		public function set ropewayTime(value:Date):void	
		{
			_source.DeteDate = value;
		}
		
		/**
		 * 报警类型
		 * 0-正常
		 * 1-平均值报警
		 * 2-单次值报警
		 **/
		public var alarm:Number = 0;
				
		public function get fromRopeStation():String	
		{
			return _source.FromRopeStation;
		}
		public function set fromRopeStation(value:String):void	
		{
			_source.FromRopeStation = value;
		}
		
		public function get fromRopeStationType():Number	
		{
			var s:String = String(_source.FromRopeStation);
			if(s.length > 3)
				s = s.substr(s.length - 4,3);
			if(s == "驱动站")
				return 1;
			else if(s == "回转站")
				return 2;
			return 0;
		}
		public function set fromRopeStationType(value:Number):void	
		{
		}
		
		public function get fromRopeWay():String	
		{
			var s:String = String(_source.FromRopeStation);
			if(s.length > 3)
				s = s.substr(0,3) + "索道";
			return s;
		}
		public function set fromRopeWay(value:String):void	
		{
			//_source.FromRopeWay = value;
		}
		
		private var _source:Object;
		
		public function ForceVO(source:Object)
		{
			_source = source;			
		}
		
		public function toString():String
		{
			return com.adobe.serialization.json.JSON.encode(_source);
		}
	}
}