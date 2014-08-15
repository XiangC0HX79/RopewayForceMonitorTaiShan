package app.model.vo
{
	public class EngineSndVO extends EngineVO
	{		
		override public function get pos():int
		{
			return EngineVO.SECOND;
		}
		
		override public function get fullName():String
		{
			return super.deviceName;
		}
		
		override public function get deviceName():String
		{
			return "温度二";
		}
		
		public function EngineSndVO(rw:RopewayVO)
		{
			super(rw);
		}
	}
}