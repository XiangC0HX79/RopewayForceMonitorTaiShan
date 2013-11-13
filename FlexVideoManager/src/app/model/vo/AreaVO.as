package app.model.vo
{
	[Bindable]
	public class AreaVO
	{
		public function get id():Number
		{
			return _source.id;
		}
		public function set id(value:Number):void
		{
			_source.id = value;
		}
		
		public function get title():String
		{
			return _source.title;
		}
		public function set title(value:String):void
		{
			_source.title = value;
		}
		
		public function get imageSrc():String
		{
			IFDEF::Debug
			{
				return "http://localhost:6361/VideoManager/" + _source.imageSrc;
			}
			
			IFDEF::Release
			{
				return _source.imageSrc;
			}
		}
		public function set imageSrc(value:String):void
		{
			_source.imageSrc = value;
		}
							   
		private var _source:Object;
		
		public function AreaVO(source:Object)
		{
			_source = source;
		}
	}
}