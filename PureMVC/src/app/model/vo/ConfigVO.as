package app.model.vo
{
	import flash.utils.Dictionary;

	[Bindable]
	public class ConfigVO
	{
		//public var station:String;
		
		public var stations:Array;
		
		/*public var serverIp:String;
		
		public var serverPort:int;
		
		public var stationsid:Array;*/
		
		public var dictStationIdByName:Dictionary = new Dictionary;
		
		public function getStationNameById(value:String):String
		{
			for(var key:String in dictStationIdByName)
			{
				if(dictStationIdByName[key] == value)
					return key;
			}
			
			return null;
		}
	}
}