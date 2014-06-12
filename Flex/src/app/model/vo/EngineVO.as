package app.model.vo
{	
	import mx.collections.ArrayCollection;
	
	import app.model.dict.RopewayDict;

	[Bindable]
	public class EngineVO
	{
		public static const FIRST:int = 0;
		public static const SECOND:int = 1;
		
		public var ropeway:RopewayDict;
		
		public var pos:int;
		
		public var history:ArrayCollection = new ArrayCollection;
		
		public function get lastTemp():EngineTempVO
		{
			return (history.length > 0)?history[history.length - 1]:null;
		}
		
		public function EngineVO()
		{
		}
		
		public function AddItem(et:EngineTempVO):void
		{			
			history.addItem(et);
		}
	}
}