package custom.components
{
	import spark.components.Label;
	import spark.components.SkinnableContainer;
	
	public class SkinnableTitleContainer extends SkinnableContainer
	{
		[SkinPart(required="true")]  
		public var lbTitle:Label;  
		
		private var _title:String;		
		public function set title (value:String):void 
		{
			_title = value;
		}
		
		public function get title ():String 
		{
			return _title;
		}
		
		public function SkinnableTitleContainer()
		{
			super();
		}
		
		override protected function partAdded(partName:String, instance:Object):void 
		{
			super.partAdded(partName, instance);
			
			if( instance == lbTitle )
				lbTitle.text = _title;
		}
	}
}