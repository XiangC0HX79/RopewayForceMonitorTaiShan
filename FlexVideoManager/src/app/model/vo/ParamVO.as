package app.model.vo
{
	[Bindable]
	public class ParamVO
	{
		public static const STATUS_DEFUALT:String = "StatusDefault";
		public static const STATUS_CAM_ADD:String = "StatusCamAdd";
		public static const STATUS_CAM_DEL:String = "StatusCamDel";
		
		public var status:String = STATUS_DEFUALT;
		
		public var edited:Boolean = true;
		
		public var appWidth:Number;
		public var appHeight:Number;
		
		public function ParamVO()
		{
		}
	}
}