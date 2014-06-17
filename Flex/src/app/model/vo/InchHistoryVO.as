package app.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class InchHistoryVO
	{
		private var totalDay:Number = 0; 
		
		public var aveDay:Number = 0;
		public var aveMon:Number = 0;
		public var aveThreeMon:Number = 0;
		
		public var periodAveDay:Number = 0;
		public var periodAveMon:Number = 0;
		public var periodThreeMon:Number = 0;
		
		public var his:ArrayCollection = new ArrayCollection;
		
		public function InchHistoryVO()
		{
		}
		
		public function UnshiftInch(inch:InchVO):void
		{			
			his.source.unshift(inch);
			
			totalDay += inch.value;
			aveDay = totalDay / his.length;
		}
		
		public function PushInch(inch:InchVO):void
		{			
			his.source.push(inch);
			
			totalDay += inch.value;
			aveDay = totalDay / his.length;
		}
	}
}