package app.model
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import app.model.dict.RopewayDict;
	import app.model.vo.EngineTempVO;
	import app.model.vo.EngineVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class EngineTempProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "EngineTempProxy";
		
		public function EngineTempProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get list():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function Init():void
		{
			list.removeAll();
			
			for each(var rw:RopewayDict in RopewayDict.dict)
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
		
		public function InitHistory(e:EngineVO):void
		{
			
		}
		
		public function AddItem(rw:RopewayDict,pos:int,et:EngineTempVO):void
		{			
			for each(var e:EngineVO in list)
			{
				if((rw == e.ropeway) && (pos == e.pos))
				{
					e.history.addItem(et);
					break;
				}
			}			
		}
	}
}