package app.model
{
	import flash.utils.Dictionary;
	
	import app.model.dict.RopewayStationDict;
	import app.model.vo.SurroundingTempVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SurroundingTempProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "SurroundingTempProxy";
		
		public function SurroundingTempProxy()
		{
			super(NAME, new Dictionary);
			
			for each(var rs:RopewayStationDict in RopewayStationDict.dict)
			{
				dict[rs] = new SurroundingTempVO;
			}
		}
		
		public function get dict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function Update(rs:RopewayStationDict,st:SurroundingTempVO):void
		{			
			var dest:SurroundingTempVO = dict[rs] as SurroundingTempVO;
			CustomUtil.CopyProperties(st,dest);	
		}
	}
}