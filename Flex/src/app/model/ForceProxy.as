package app.model
{	
	import mx.collections.ArrayCollection;
	
	import app.model.vo.ForceVO;
	import app.model.vo.InternalVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	
	use namespace InternalVO;
	
	public class ForceProxy extends Proxy
	{
		public static const NAME:String = "ForceProxy";
		
		public function ForceProxy()
		{
			super(NAME, new ArrayCollection);			
		}
		
	/*	public function get list():ArrayCollection
		{
			return data as ArrayCollection;
		}*/
		
		override public function onRegister():void
		{
		}
		
		public function Update(force:ForceVO):void
		{
			CustomUtil.CopyProperties(force,ForceVO.getNamed(force.rsName));
		}
	}
}