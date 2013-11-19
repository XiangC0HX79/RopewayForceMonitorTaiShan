package app.model.vo
{
	import mx.collections.ArrayCollection;

	[Bindable]
	public class AreaWheelVO
	{
		public var AreaId:int;
		
		public function get shortName():String
		{
			var id:int = int((AreaId - 1) / 2);
			var up:String = (AreaId % 2) == 0?"下":"上";
			return id.toString() + "#" + up;
		}		
		public function set shortName(value:String):void
		{
			
		}
		
		public var StandId:int;
		
		public var Black:int=0;
		
		public var Yellow:int=0;
		
		public var Red:int=0;
		
		public var Wheelarr:ArrayCollection = new ArrayCollection();
		
		public var WheelId:String;
		public var WarningStatus:int;
		public var WarningExplain:String;
		public var WheelDate:Date = new Date(1900,01,01);
		public var StandDate:Date;
		public var Wheelhour:int;
		public var Standhour:int;
		
		public function AreaWheelVO()
		{
			/*for(var i:int=1;i<=26;i++)
			{
				var obj:* = new *();
				obj.AreaId = i;
				var w:WheelVO = new WheelVO(obj);
				Wheelarr.addItem(w);
			}*/
		}
	}
}