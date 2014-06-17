package app.model
{	
	import flash.utils.Dictionary;
	
	import mx.rpc.events.ResultEvent;
	
	import app.model.dict.RopewayDict;
	import app.model.vo.InchVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class InchProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "InchProxy";
		
		public function InchProxy()
		{
			super(NAME, new Dictionary);
			
			for each(var rw:RopewayDict in RopewayDict.dict)
			{
				dict[rw] = new InchVO;
			}
		}
		
		public function get dict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function Init():void
		{			
			send2("RopeDete_RopeCarriageRela_GetList",onInit,"");
		}
		
		private function onInit(event:ResultEvent):void
		{
			var inch:InchVO = new InchVO;
			inch.date = new Date;
			inch.humi = 50;
			inch.temp = 25;
			inch.value = 500;
			
			for each(var item:InchVO in dict)
			{
				if(!item.date || (item.date.time < inch.date.time))
					CustomUtil.CopyProperties(inch,item);
			}
		}
		
		public function Update(rw:RopewayDict,inch:InchVO):void
		{
			var dest:InchVO = dict[rw] as InchVO;			
			CustomUtil.CopyProperties(inch,dest);			
		}
	}
}