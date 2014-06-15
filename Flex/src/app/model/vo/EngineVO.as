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
		
		public function get maxTemp():Number
		{
			var r:EngineTempVO;
			for each(var item:EngineTempVO in history)
			{
				if(!r || (r.temp < item.temp))
					r = item;
			}
			
			return r.temp;
		}
		
		public function get minTemp():Number
		{
			var r:EngineTempVO;
			for each(var item:EngineTempVO in history)
			{
				if(!r || (r.temp > item.temp))
					r = item;
			}
			
			return r.temp;
		}
		
		public function get aveTemp():Number
		{
			if(history.length == 0)
				return NaN;
			
			var r:Number = 0;
			for each(var item:EngineTempVO in history)
			{
				r += item.temp;
			}
			
			r /= history.length;
			
			return Math.round(r * 10) / 10;
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