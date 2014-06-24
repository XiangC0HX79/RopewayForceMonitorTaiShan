package app.model
{
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.vo.EngineTempVO;
	import app.model.vo.EngineVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	public class EngineProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String = "EngineProxy";
		public static const SRNAME:String = "EngineProxySR";
		
		public function EngineProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get list():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function load():void
		{
			list.removeAll();
			
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
			
			sendNotification(ApplicationFacade.NOTIFY_ENGINE_LOADED,NAME);
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