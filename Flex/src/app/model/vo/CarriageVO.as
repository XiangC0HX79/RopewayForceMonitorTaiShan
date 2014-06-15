package app.model.vo
{
	import com.adobe.serialization.json.JSON;
	
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;
	
	import app.model.dict.RopewayDict;

	[Bindable]
	public class CarriageVO
	{
		public static const ALL:CarriageVO = new CarriageVO(new ObjectProxy({RopeCode:"所有抱索器",CarriageCode:"所有吊箱"}));
		
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
		public function get ropeWay():RopewayDict	
		{
			return RopewayDict.GetRopewayByLable(String(_source.FromRopeWay));
		}
		public function set ropeWay(value:RopewayDict):void	
		{
			_source.FromRopeWay = value.fullName;
		}
		
		/**
		 * 是否使用
		 * */
		public function get isUse():Boolean
		{
			return _source.IsUse == 0;
		}
		public function set isUse(value:Boolean):void
		{
			_source.IsUse = value?0:1;
		}
		
		/**
		 * RFID电量
		 **/
		public function get eletric():Boolean	
		{
			return _source.RFIDDL == 0;
		}
		public function set eletric(value:Boolean):void	
		{
			_source.RFIDDL = value?0:1;
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
		 * 最后更新人
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
		 * 最后更新时间
		 **/
		public function get lastUpdateDatetime():Date	
		{
			return _source.lastUpdateDatetime;
		}
		public function set lastUpdateDatetime(value:Date):void	
		{
			_source.lastUpdateDatetime = value;
		}
				
		private var _source:ObjectProxy;
		
		/**
		 * 驱动站抱索力信息
		 * */
		public var fstForce:RopewayStationForceVO;
		
		/**
		 * 回转站抱索力信息
		 * */
		public var sndForce:RopewayStationForceVO;
		
		public function CarriageVO(source:ObjectProxy = null)
		{
			if(source)
				_source = source;	
			else
			{
				_source = new ObjectProxy({});
				this.isUse = true;
				this.eletric = true;
				this.memo = "";
				this.lastUpdateUser = "";
				this.lastUpdateDatetime = new Date;
			}
		}
		
		public function toString():String
		{
			return com.adobe.serialization.json.JSON.encode(_source.valueOf());
		}
	}
}