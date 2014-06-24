package app.model
{
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.vo.InchVO;
	import app.model.vo.InchValueVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	public class InchProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String = "InchProxy";
		public static const SRNAME:String = "InchProxySR";
		
		public function InchProxy()
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
				var inch:InchVO = new InchVO;
				inch.ropeway = rw;
				list.addItem(inch);
			}
			
			sendNotification(ApplicationFacade.NOTIFY_INCH_LOADED,NAME);
		}
				
		public function retrieveInch(rw:RopewayVO):InchVO
		{
			for each(var item:InchVO in list)
			{
				if(item.ropeway.fullName == rw.fullName)
					return item;
			}
			
			return null;
		}
		
		public function AddInch(rw:RopewayVO,inchValue:InchValueVO):void
		{			
			var inch:InchVO = retrieveInch(rw);
			inch.PushInch(inchValue);
		}
	}
}