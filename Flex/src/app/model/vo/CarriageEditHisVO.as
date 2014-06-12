package app.model.vo
{
	import com.adobe.serialization.json.JSON;
	
	import mx.utils.ObjectProxy;
	
	import app.model.dict.RopewayDict;
	
	[Bindable]
	public class CarriageEditHisVO
	{
		/**
		 * 主键
		 * */
		public function get id():Number
		{
			return _source.Id;
		}
		public function set id(value:Number):void
		{
			_source.Id = value;
		}
		
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
		 * RFID
		 * */
		public function get ropewayRFID():String
		{
			return _source.RFIDCode;
		}
		public function set ropewayRFID(value:String):void
		{
			_source.RFIDCode = value;
		}
		
		/**
		 * 所属索道
		 **/
		public function get ropeway():RopewayDict	
		{
			return RopewayDict.GetRopewayByLable(String(_source.RopeWay));
		}
		public function set ropeway(value:RopewayDict):void	
		{
			_source.RopeWay = value.fullName;
		}
		
		/**
		 * 备注
		 **/
		public function get memo():String	
		{
			return _source.Memo;
		}
		public function set memo(value:String):void	
		{
			_source.Memo = value;
		}
		
		/**
		 * 更新人
		 **/
		public function get updateUser():String	
		{
			return _source.UpdateUser;
		}
		public function set updateUser(value:String):void	
		{
			_source.UpdateUser = value;
		}
		
		/**
		 * 更新时间
		 **/
		public function get updateDatetime():Date	
		{
			return _source.UpdateDatetime;
		}
		public function set updateDatetime(value:Date):void	
		{
			_source.UpdateDatetime = value;
		}
				
		private var _source:ObjectProxy;
		
		public function CarriageEditHisVO(source:ObjectProxy = null)
		{
			if(source)
				_source = source;	
			else
			{
				_source = new ObjectProxy({});
				this.memo = "";
				this.updateUser = "";
				this.updateDatetime = new Date;
			}
		}
		
		public function toString():String
		{
			return JSON.encode(_source.valueOf());
		}
	}
}