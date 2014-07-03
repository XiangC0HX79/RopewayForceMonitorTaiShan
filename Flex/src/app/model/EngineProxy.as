package app.model
{
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.vo.EngineTempVO;
	import app.model.vo.EngineVO;
	import app.model.vo.InternalVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	use namespace InternalVO;
	
	public class EngineProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String = "EngineProxy";
		public static const SRNAME:String = "EngineProxySR";
		
		public static const LOADED:String = "EngineProxy/Loaded";
		public static const FAILED:String = "EngineProxy/Failed";
		
		public function EngineProxy()
		{
			super(NAME,new Array);
		}
		
		public function get list():ArrayCollection
		{			
			return new ArrayCollection(data as Array);
		}
						
		public function load():void
		{			
			/*setData(EngineVO.loadEngine(
				RopewayProxy(facade.retrieveProxy(RopewayProxy.NAME)).list
			));*/
			
			sendNotification(LOADED,NAME);
		}
								
		public function AddItem(rwName:String,date:Date,pos:int,temp:Number):void
		{						
			var et:EngineTempVO = new EngineTempVO;
			et.date = date;
			et.temp = temp;
			
			EngineVO.getNamed(rwName,pos).PushItem(et);
		}
	}
}