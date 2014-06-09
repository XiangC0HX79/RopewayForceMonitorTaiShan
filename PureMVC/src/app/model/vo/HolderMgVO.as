package app.model.vo
{
	import app.model.dict.MaintainTypeDict;

	[Bindable]
	public class HolderMgVO
	{
		private var source:*;
		
		public function get Id():int{return source.Id;}
		public function set Id(value:int):void{source.Id = value;}
		
		public function get LineAreaId():int{return source.LineAreaId;}
		public function set LineAreaId(value:int):void{source.LineAreaId = value;}
		
		public var LineAreaLable:String;
		
		public function get RopeWay():int{return source.RopeWay;}
		public function set RopeWay(value:int):void{source.RopeWay = value;}
		
		public var RopeWayName:String;
		
		public function get IsHour():Boolean{return source.IsHour;}
		public function set IsHour(value:Boolean):void{source.IsHour = value?1:0;}
		
		public function get IsDay():Boolean{return source.IsDay;}
		public function set IsDay(value:Boolean):void{source.IsDay = value?1:0;}
		
		public function get HourNum():String{return source.HourNum;}
		public function set HourNum(value:String):void{source.HourNum = int(value);}
		
		public function get DayNum():String{return source.DayNum;}
		public function set DayNum(value:String):void{source.DayNum = int(value);}
		
		public function get HourPoint():String{return source.HourPoint;}
		public function set HourPoint(value:String):void{source.HourPoint = int(value);}
		
		public function get DayPoint():String{return source.DayPoint;}
		public function set DayPoint(value:String):void{source.DayPoint = int(value);}
				
		public function get Type():int{return source.Type;}
		public function set Type(value:int):void{source.Type = value;}
		
		public function get TypeObject():MaintainTypeDict
		{
			return  MaintainTypeDict.dict[this.Type];
		}
		public function set TypeObject(value:MaintainTypeDict):void
		{
			source.Type = value.DicId;
		}
				
		public function get IsChangeHour():Boolean{return source.IsChangeHour;}
		public function set IsChangeHour(value:Boolean):void{source.IsChangeHour = value?1:0;}
		
		public function get IsChangeDay():Boolean{return source.IsChangeDay;}
		public function set IsChangeDay(value:Boolean):void{source.IsChangeDay = value?1:0;}
		
		public function get ChangeHourNum():String{return source.ChangeHourNum;}
		public function set ChangeHourNum(value:String):void{source.ChangeHourNum = int(value);}
		
		public function get ChangeDayNum():String{return source.ChangeDayNum;}
		public function set ChangeDayNum(value:String):void{source.ChangeDayNum = int(value);}
		
		public function get ChangeHourPoint():String{return source.ChangeHourPoint;}
		public function set ChangeHourPoint(value:String):void{source.ChangeHourPoint = int(value);}
		
		public function get ChangeDayPoint():String{return source.ChangeDayPoint;}
		public function set ChangeDayPoint(value:String):void{source.ChangeDayPoint = int(value);}
		
		public function HolderMgVO(o:* = null)
		{
			if(o)
			{
				this.source = o;
			}
			else
			{
				this.source = {};
				this.source.Id =0;
				this.source.LineAreaId = 0;
				this.source.RopeWay = 0;
				this.source.IsHour = 0;
				this.source.IsDay = 0;
				this.source.HourNum = 0;
				this.source.DayNum = 0;
				this.source.HourPoint = 0;
				this.source.DayPoint = 0;
				this.source.Type = MaintainTypeDict.DEFAUT.DicId;
				this.source.IsChangeHour = 0;
				this.source.IsChangeDay = 0;			
				this.source.ChangeHourNum = 0;
				this.source.ChangeDayNum = 0;
				this.source.ChangeHourPoint = 0;
				this.source.ChangeDayPoint = 0;
			}
		}
		
		public function get valueOf():*
		{
			return source;
		}
		
		public function copy(item:HolderMgVO):void
		{
			this.Id = item.Id;
			this.LineAreaId = item.LineAreaId;
			this.RopeWay = item.RopeWay;
			this.IsHour = item.IsHour;
			this.IsDay = item.IsDay;
			this.HourNum = item.HourNum;
			this.DayNum = item.DayNum;
			this.HourPoint = item.HourPoint;
			this.DayPoint = item.DayPoint;
			this.Type = item.Type;
			this.IsChangeHour = item.IsChangeHour;
			this.IsChangeDay = item.IsChangeDay;			
			this.ChangeHourNum = item.ChangeHourNum;
			this.ChangeDayNum = item.ChangeDayNum;
			this.ChangeHourPoint = item.ChangeHourPoint;
			this.ChangeDayPoint = item.ChangeDayPoint;			
			
			this.LineAreaLable = item.LineAreaLable;
			this.RopeWayName = item.RopeWayName;
		}
	}
}