package app.model.vo
{	
	import com.adobe.serialization.json.JSON;
	
	import mx.utils.ObjectProxy;
	import mx.utils.object_proxy;

	[Bindable]
	public class RopewayForceVO
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
		 * 时间
		 **/
		public function get ropewayTime():Date	
		{
			return _source.DeteDate;
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
		
		//所属报索站
		//public var ropewayStation:String;
		
		private var _source:ObjectProxy;
		
		public function RopewayForceVO(source:ObjectProxy)
		{
			_source = source;			
		}
		
		public function toString():String
		{
			return JSON.encode(_source.valueOf());
		}
	}
}