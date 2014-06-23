package app.model.vo
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class RopewayStationVO
	{
		public static const FIRST:String = "驱动站";
		
		public static const SECOND:String = "回转站";
		
		public var ropeway:RopewayVO;
				
		public var station:String;
		
		public var alarmForce:Number = 50;
		
		public var fullName:String;
		
		public function RopewayStationVO(value:String)
		{
			this.fullName = value;
			
			if(value.indexOf(FIRST) >= 0)
			{
				this.station = FIRST;
				
				var shortName:String = value.substr(0,value.indexOf(FIRST));	
				
				this.ropeway = new RopewayVO(shortName + "索道");
				
			}
			else if(value.indexOf(SECOND) >= 0)
			{
				this.station = SECOND;
				
				shortName = value.substr(0,value.indexOf(SECOND));	
				
				this.ropeway = new RopewayVO(shortName + "索道");				
			}
		}
	}
}