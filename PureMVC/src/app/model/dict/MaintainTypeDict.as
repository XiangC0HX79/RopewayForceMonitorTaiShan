package app.model.dict
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class MaintainTypeDict
	{
		public var DicId:int;
		public var DicValue:String;
		
		public static var DEFAUT:MaintainTypeDict;
		
		public static var dict:Dictionary = new Dictionary;		
		
		public function MaintainTypeDict(o:*)
		{
			this.DicId = o.DicId;
			this.DicValue = o.DicValue;
			MaintainTypeDict.dict[this.DicId] = this;			
		}
		
		public static function get list():ArrayCollection
		{
			var col:ArrayCollection = new ArrayCollection;
			
			for each(var item:MaintainTypeDict in dict)
				col.addItem(item);
				
			return col;
		}
	}
}