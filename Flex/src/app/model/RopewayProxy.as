package app.model
{
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import app.model.vo.RopewayVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	public class RopewayProxy extends Proxy
	{
		public static const NAME:String = "RopewayProxy";
		
		public function RopewayProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get list():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		override public function onRegister():void
		{
			list.addItem(RopewayVO.ZHONG_TIAN_MEN);
			list.addItem(RopewayVO.TAO_HUA_YUAN);
		}
	}
}