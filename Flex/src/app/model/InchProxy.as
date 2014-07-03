package app.model
{
	import mx.collections.ArrayCollection;
	
	import app.model.vo.InchVO;
	import app.model.vo.InchValueVO;
	import app.model.vo.InternalVO;
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	use namespace InternalVO;
	
	public class InchProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String = "InchProxy";
		public static const SRNAME:String = "InchProxySR";
		
		public static const LOADED:String = "InchProxy/Loaded";
		public static const FAILED:String = "InchProxy/Failed";
		
		public function InchProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function load():void
		{			
			sendNotification(LOADED,NAME);
		}
		
		public function AddInch(rwName:String,date:Date,value:Number):void
		{			
			var inchValue:InchValueVO = new InchValueVO;
			inchValue.date = date;
			inchValue.value = Number(value.toFixed(2));
			
			InchVO.getName(rwName).PushInch(inchValue);
		}
	}
}