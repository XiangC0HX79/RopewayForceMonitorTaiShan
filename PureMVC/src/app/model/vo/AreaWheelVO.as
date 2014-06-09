package app.model.vo
{
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	[Bindable]
	public class AreaWheelVO
	{
		public var AreaId:int;
		
		public function get shortName():String
		{
			var id:int = int((AreaId - 1) / 2);
			var ids:String;
			
			if(FlexGlobals.topLevelApplication.Station == "中天门")
			{										
				switch(id)
				{
					case 0:
						ids = "驱动站支架";
						break;
					case 8:
						ids = "8A#支架";
						break;
					case 9:
						ids = "8B#支架";
						break;
					case 10:
						ids = "9#支架";
						break;
					case 11:
						ids = "10#支架";
						break;
					case 12:
						ids = "11A#支架";
						break;
					case 13:
						ids = "11B#支架";
						break;
					case 14:
						ids = "11C#支架";
						break;
					case 15:
						ids = "回转站支架";
						break;
					default:
						ids = id.toString() + "#支架";
						break;
				}	
								
				var up:String = (AreaId % 2) == 0?"上行":"下行";
			}
			else if(FlexGlobals.topLevelApplication.Station == "后石坞")
			{				
				if(id == 0)
					ids = "驱动站支架";
				else if(id == 9)
					ids = "回转站支架";
				else
					ids = id.toString() + "#支架";
				
				up = (AreaId % 2) == 0?"下行":"上行";
			}
			else
			{
				if(id == 0)
					ids = "驱动站支架";
				else if(id == 12)
					ids = "回转站支架";
				else
					ids = id.toString() + "#支架";
				
				up = (AreaId % 2) == 0?"下行":"上行";
			}
			
			return ids + up;
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