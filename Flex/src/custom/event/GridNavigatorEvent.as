package custom.event
{
	import flash.events.Event;
	
	public class GridNavigatorEvent extends Event
	{
		public static const PAGE_CHANGE:String = "PageChange"; 
		
		public var pageIndex:int;
		
		public function GridNavigatorEvent(type:String, pageIndex:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.pageIndex = pageIndex;
			
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new GridNavigatorEvent(this.type,this.pageIndex,this.bubbles,this.cancelable);
		}
	}
}