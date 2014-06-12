package app.model.vo
{	
	import com.adobe.serialization.json.JSON;
	
	import app.model.dict.RopewayDict;
	import app.model.dict.RopewayStationDict;

	[Bindable]
	/**
	 * 
	 * 抱索力校准信息
	 * @author 黄湘
	 * 
	 */
	public class RopeForceAjustVO
	{
		/**
		 * 所属索道站
		 **/
		public function get ropewayStation():RopewayStationDict	
		{
			return RopewayStationDict.GetRopewayStationByLable(String(_source.FromRopeStation));
		}
		public function set ropewayStation(value:RopewayStationDict):void	
		{
			_source.FromRopeStation = value.fullName;
		}
		
		/**
		 * 所属索道
		 **/
		public function get ropeway():RopewayDict	
		{
			return RopewayDict.GetRopewayByLable(String(_source.FromRoapWay));
		}
		public function set ropeway(value:RopewayDict):void	
		{
			_source.FromRoapWay = value.fullName;
		}
				
		/**
		 * 校准时间
		 **/
		public function get checkDatetime():Date
		{
			return _source.CheckDatetime;
		}
		public function set checkDatetime(value:Date):void
		{
			_source.CheckDatetime = value;
		}
		
		/**
		 * 更新人
		 **/
		public function get lastUpdateUser():String
		{
			return _source.lastUpdateUser;
		}
		public function set lastUpdateUser(value:String):void
		{
			_source.lastUpdateUser = value;
		}
		
		/**
		 * 更新时间
		 **/
		public function get lastUpdateDatetime():Date
		{
			return _source.lastUpdateDatetime;
		}
		public function set lastUpdateDatetime(value:Date):void
		{
			_source.lastUpdateDatetime = value;
		}
		
		private var _source:*;
		
		public function RopeForceAjustVO(value:*)
		{
			_source = value;
		}
		
		public function toString():String
		{
			return JSON.encode(_source);
		}
	}
}