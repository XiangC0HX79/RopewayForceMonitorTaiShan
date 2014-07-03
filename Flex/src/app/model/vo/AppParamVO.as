package app.model.vo
{
	[Bindable]
	public class AppParamVO
	{
		private var _selRopeway:RopewayVO;

		public function get selRopeway():RopewayVO
		{
			return _selRopeway;
		}

		public function set selRopeway(value:*):void
		{
			_selRopeway = value;
		}
		
		public function AppParamVO()
		{
		}
	}
}