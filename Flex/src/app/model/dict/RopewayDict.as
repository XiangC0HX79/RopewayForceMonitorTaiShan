package app.model.dict
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;

	[Bindable]
	public class RopewayDict
	{
		public static const ZHONG_TIAN_MEN:RopewayDict = new RopewayDict({id:2,lable:"中天门"});		
		public static const TAO_HUA_YUAN:RopewayDict = new RopewayDict({id:3,lable:"桃花源"});
		
		public var id:int;
		public var lable:String;
		
		public function get fullName():String
		{
			return lable + "索道";
		}
		
		public static var dict:Dictionary;
		
		public function RopewayDict(o:*)
		{
			this.id = o.id;
			this.lable = o.lable;
		}
		
		public static function get list():ArrayCollection
		{
			var r:Array = [];
			
			for each(var rw:RopewayDict in dict)
			{
				r.push(rw);
			}
			
			r.sortOn("id",Array.NUMERIC);
			
			return new ArrayCollection(r);
		}
		
		public static function GetRopewayByLable(l:String):RopewayDict
		{
			for each(var rw:RopewayDict in dict)
			{
				if((l == rw.fullName) || (l == rw.lable))
					return rw;
			}
			
			return null;
		}
	}
}