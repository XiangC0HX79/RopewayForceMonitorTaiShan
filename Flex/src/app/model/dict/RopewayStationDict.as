package app.model.dict
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class RopewayStationDict
	{
		public static const FIRST:int = 1;
		
		public static const SECOND:int = 2;
		
		public var ropeway:RopewayDict;
		
		public var station:int;
		
		public function get fullName():String
		{
			return ropeway.lable + (station == FIRST?"驱动站":"回转站");
		}
		
		public static function get list():ArrayCollection
		{
			var r:Array = [];
			
			for each(var rw:RopewayDict in RopewayDict.list)
			{				
				var s:RopewayStationDict = new RopewayStationDict;			
				s.ropeway = rw;
				s.station = RopewayStationDict.FIRST;	
				r.push(s);
				
				s = new RopewayStationDict();
				s.ropeway = rw;
				s.station = RopewayStationDict.SECOND;	
				r.push(s);
			}
			
			return new ArrayCollection(r);
		}
		
		public function RopewayStationDict()
		{
		}
		
		public static function GetRopewayStationByLable(l:String):RopewayStationDict
		{
			for each(var rw:RopewayStationDict in list)
			{
				if(l == rw.fullName)
					return rw;
			}
			
			return null;
		}
	}
}