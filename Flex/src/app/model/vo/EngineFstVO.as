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
			return super.deviceName;
		}
		
		public function EngineFstVO(rw:RopewayVO)
		{
			super(rw);
		}
	}
}