package app.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class ConfigVO
	{
		public var user:String;
				
		public var station:String;
		
		public var stations:ArrayCollection;
		
		public var serverIp:String;
		
		public var serverPort:int;
		
		public var pin:Boolean = false;
		
		//public static var debug:Boolean = true;
	}
}