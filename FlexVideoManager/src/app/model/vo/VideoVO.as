package app.model.vo
{
	[Bindable]
	public class VideoVO
	{
		public function get id():Number
		{
			return _source.id;
		}
		public function set id(value:Number):void
		{
			_source.id = value;
		}
		
		public function get areaId():Number
		{
			return _source.areaId;
		}
		public function set areaId(value:Number):void
		{
			_source.areaId = value;
		}
		
		public function get X():Number
		{
			return _source.X;
		}
		public function set X(value:Number):void
		{
			_source.X = value;
		}
		
		public function get Y():Number
		{
			return _source.Y;
		}
		public function set Y(value:Number):void
		{
			_source.Y = value;
		}
		
		public function get title():String
		{
			return _source.title;
		}
		public function set title(value:String):void
		{
			_source.title = value;
		}
		
		public function get info():String
		{
			return _source.info;
		}
		public function set info(value:String):void
		{
			_source.info = value;
		}
		
		private var _source:Object;
		
		public function VideoVO(source:Object)
		{
			_source = source;
		}
		
		public function clone():VideoVO
		{
			return new VideoVO(_source);
		}
	}
}