package app.model.vo
{	
	import mx.collections.ArrayCollection;
	

	[Bindable]
	public class EngineVO
	{
		public static const FIRST:int = 0;
		public static const SECOND:int = 1;
		
		public var ropeway:RopewayVO;
		
		public var pos:int;
		
		public var history:ArrayCollection = new ArrayCollection;
		
		public var firstTemp:EngineTempVO;
		
		public var lastTemp:EngineTempVO;
		
		public var maxTemp:Number;
		
		public var minTemp:Number;
		
		public var aveTemp:Number;
		
		private var totalTemp:Number = 0;
		
		public function EngineVO()
		{
		}
		
		public function UnshiftInch(et:EngineTempVO):void
		{			
			history.source.unshift(et);
			
			firstTemp = et;
			
			if(history.length == 1)
				lastTemp = et;
			
			totalTemp += et.temp;
			
			aveTemp = totalTemp / history.length;
			
			maxTemp = maxTemp?Math.max(maxTemp,et.temp):et.temp;
			
			minTemp = minTemp?Math.min(minTemp,et.temp):et.temp;
		}
		
		public function PushInch(et:EngineTempVO):void
		{			
			history.source.push(et);
						
			if(history.length == 1)
				firstTemp = et;
			
			lastTemp = et;
			
			totalTemp += et.temp;
			
			aveTemp = totalTemp / history.length;
			
			maxTemp = maxTemp?Math.max(maxTemp,et.temp):et.temp;
			
			minTemp = minTemp?Math.min(minTemp,et.temp):et.temp;
		}
	}
}