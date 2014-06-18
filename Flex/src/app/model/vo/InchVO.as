package app.model.vo
{
	import mx.collections.ArrayCollection;
	
	import app.model.dict.RopewayDict;

	[Bindable]
	public class InchVO
	{
		private var totalDay:Number = 0; 
		
		public var ropeway:RopewayDict;
		
		public var aveDay:Number = 0;
		public var aveMon:Number = 0;
		public var aveThreeMon:Number = 0;
		
		public var periodAveDay:Number = 0;
		public var periodAveMon:Number = 0;
		public var periodThreeMon:Number = 0;
		
		public var his:ArrayCollection = new ArrayCollection;
				
		public function get lastValue():InchValueVO
		{
			return (his.length > 0)?his[his.length - 1]:null;
		}
		
		public function InchVO()
		{
		}
		
		public function UnshiftInch(inch:InchValueVO):void
		{			
			his.source.unshift(inch);
			
			totalDay += inch.value;
			aveDay = totalDay / his.length;
		}
		
		public function PushInch(inch:InchValueVO):void
		{			
			his.source.push(inch);
			
			totalDay += inch.value;
			aveDay = totalDay / his.length;
		}
	}
}