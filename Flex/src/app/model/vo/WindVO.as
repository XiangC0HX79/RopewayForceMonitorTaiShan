package app.model.vo
{
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;

	[Bindable]
	public class WindVO
	{
		public function get uid():String
		{
			return UIDUtil.getUID(this);
		}
		
		public var bracket:BracketVO;
				
		public var history:ArrayCollection = new ArrayCollection;
		
		public var maxValue:Number;
		
		public var minValue:Number;
		
		public var firstValue:WindValueVO;
		
		public var lastValue:WindValueVO;
		
		public function WindVO(bracket:BracketVO)
		{
			this.bracket = bracket;
		}
		
		public function UnshiftInch(et:WindValueVO):void
		{			
			history.source.unshift(et);
			
			firstValue = et;
			
			if(history.length == 1)
				lastValue = et;
			
			maxValue = maxValue?Math.max(maxValue,et.speed):et.speed;
			
			minValue = minValue?Math.min(minValue,et.speed):et.speed;
		}
		
		public function PushInch(et:WindValueVO):void
		{			
			history.source.push(et);
			
			if(history.length == 1)
				firstValue = et;
			
			lastValue = et;
			
			maxValue = maxValue?Math.max(maxValue,et.speed):et.speed;
			
			minValue = minValue?Math.min(minValue,et.speed):et.speed;
		}
	}
}