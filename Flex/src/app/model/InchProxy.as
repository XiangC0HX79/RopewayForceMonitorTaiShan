package app.model
{
	import com.adobe.utils.DateUtil;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	
	import app.model.dict.RopewayDict;
	import app.model.vo.InchVO;
	import app.model.vo.InchValueVO;
	
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
			send("RopeDete_RopeCarriageRela_GetList",onInit,"");
		}
		
		private function onInit(event:ResultEvent):void
		{
			var inch:InchValueVO = new InchValueVO;
			inch.date = DateUtil.addDateTime('m',-5, new Date);
			inch.humi = 50;
			inch.temp = 25;
			inch.value = 500;
			
			for each(var item:InchVO in dict)
			{
				item.UnshiftInch(inch);
			}
		}
		
		public function AddInch(rw:RopewayDict,inch:InchValueVO):void
		{
			var inchHistory:InchVO = dict[rw];
			inchHistory.PushInch(inch);
		}
	}
}