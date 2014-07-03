package app.model.vo
{
	import flash.errors.IllegalOperationError;

	public class EngineSndVO extends EngineVO
	{		
		override public function get pos():int
		{
			return EngineVO.SECOND;
		}
		
		override public function set pos(value:int):void
		{
			throw(new IllegalOperationError("调用抽象方法"));
		}
		
		public function EngineSndVO(rw:RopewayVO)
		{
			super(rw);
		}
	}
}