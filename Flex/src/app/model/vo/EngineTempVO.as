package app.model.vo
{
	[Bindable]
	public class EngineTempVO
	{		
		//public var engine:EngineDict;
		
		public var date:Date;
		
		public var temp:Number;
		
		public var alarm:int = 0;
		
		public function EngineTempVO()
		{
		}
	}
}