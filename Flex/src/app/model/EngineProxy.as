package app.model
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import app.model.vo.EngineTempVO;
	import app.model.vo.EngineVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.interfaces.IProxy;
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class EngineProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "EngineProxy";
		
		public function EngineProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get list():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		override public function onRegister():void
		{
			var ropewayProxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
			for each(var rw:RopewayVO in ropewayProxy.list)
			{				
				var e:EngineVO = new EngineVO;
				e.ropeway = rw;
				e.pos = EngineVO.FIRST;
				list.addItem(e);
				
				e = new EngineVO;
				e.ropeway = rw;
				e.pos = EngineVO.SECOND;
				list.addItem(e);
			}
		}
						
		public function retreiveEngine(rw:RopewayVO,pos:int):EngineVO
		{			
			for each(var e:EngineVO in list)
			{
				if((rw.fullName == e.ropeway.fullName) && (pos == e.pos))
				{
					return e;
				}
			}			
			
			return null;
		}
		
		public function AddItem(rw:RopewayVO,pos:int,et:EngineTempVO):void
		{			
			var engine:EngineVO = retreiveEngine(rw,pos);
			engine.PushInch(et);
		}
	}
}