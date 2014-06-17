package app.model.vo
{	
	import app.model.dict.RopewayDict;

	[Bindable]
	public class ConfigVO
	{
		public var user:String;
		
		public var serverIp:String;
		
		public var serverPort:int;
				
		public var ropeway:RopewayDict;
	}
}