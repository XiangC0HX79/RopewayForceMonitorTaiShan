package app.model.vo
{
	public class EngineFstVO extends EngineVO
	{		
		override public function get pos():int
		{
			return EngineVO.FIRST;
		}
				
		override public function get fullName():String
		{
			return super.deviceName;
		}
		
		override public function get deviceName():String
		{
			return "温度一";
		}
		
		public function EngineFstVO(rw:RopewayVO)
		{
			super(rw);
		}
	}
}