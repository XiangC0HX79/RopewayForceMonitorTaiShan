package app.model
{	
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.vo.InternalVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	use namespace InternalVO;
	
	public class RopewayProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String= "RopewayProxy";
		public static const SRNAME:String= "RopewayProxySR";
				
		public static const LOADED:String = "RopewayProxy/Loaded";
		public static const FAILED:String = "RopewayProxy/Failed";
				
		public function RopewayProxy(rwId:String)
		{
			super(NAME,new Array);
			
			RopewayVO.rwId = rwId;
		}
		
		public function get list():ArrayCollection
		{			
			return new ArrayCollection(data as Array);
		}
		
		public function load():void
		{
			RopewayVO.loadRopeway();
			
			setData(RopewayVO.list);
			
			sendNotification(LOADED,NAME);
			
			sendNotification(ApplicationFacade.ACTION_UPDATE_ROPEWAY_LIST,list);
		}
	}
}