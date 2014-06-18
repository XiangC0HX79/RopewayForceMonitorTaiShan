package forceMonitor.model.vo
{	
	import com.adobe.serialization.json.JSON;

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
		public function get fromRoapWay():String
		{
			return _source.FromRoapWay;
		}
		public function set fromRoapWay(value:String):void
		{
			_source.FromRoapWay = value;
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