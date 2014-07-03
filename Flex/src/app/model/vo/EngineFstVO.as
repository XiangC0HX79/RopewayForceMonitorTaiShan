package app.model.vo
{
	import flash.errors.IllegalOperationError;

	public class EngineFstVO extends EngineVO
	{		
		override public function get pos():int
		{
			return EngineVO.FIRST;
		}
		
		override public function set pos(value:int):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function EngineFstVO(rw:RopewayVO)
		{
			super(rw);
		}
	}
}