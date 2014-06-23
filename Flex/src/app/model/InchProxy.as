package app.model
{
	import mx.collections.ArrayCollection;
	
	import app.model.vo.InchVO;
	import app.model.vo.InchValueVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class InchProxy extends Proxy
	{
		public static const NAME:String = "InchProxy";
		
		public function InchProxy()
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
				var inch:InchVO = new InchVO;
				inch.ropeway = rw;
				list.addItem(inch);
			}
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