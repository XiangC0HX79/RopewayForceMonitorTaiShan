package app.model.vo
{
	import mx.collections.ArrayCollection;
	

	[Bindable]
	public class InchVO
	{
		private var totalDay:Number = 0; 
		
		public var ropeway:RopewayVO;
		
		public var aveDay:Number = 0;
		public var aveMon:Number = 0;
		public var aveThreeMon:Number = 0;
		
		public var periodAveDay:Number = 0;
		public var periodAveMon:Number = 0;
		public var periodThreeMon:Number = 0;
		
		public var maxValue:Number;
		
		public var minValue:Number;
		
		public var his:ArrayCollection = new ArrayCollection;
				
		public var firstValue:InchValueVO;
		
		public var lastValue:InchValueVO;
		
		public function InchVO()
		{
		}
		
		public function UnshiftInch(inch:InchValueVO):void
		{			
			his.source.unshift(inch);
			
			firstValue = inch;
			
			if(his.length == 1)
				lastValue = inch;
			
			totalDay += inch.value;
			aveDay = totalDay / his.length;
			
			maxValue = maxValue?Math.max(maxValue,inch.value):inch.value;
			
			minValue = minValue?Math.min(minValue,inch.value):inch.value;
		}
		
		public function PushInch(inch:InchValueVO):void
		{			
			his.source.push(inch);
			
			if(his.length == 1)
				firstValue = inch;
			
			lastValue = inch;
			
			totalDay += inch.value;
			aveDay = totalDay / his.length;
			
			maxValue = maxValue?Math.max(maxValue,inch.value):inch.value;
			
			minValue = minValue?Math.min(minValue,inch.value):inch.value;
		}
	}
}