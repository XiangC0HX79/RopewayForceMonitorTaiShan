package app.model
{
	import com.adobe.utils.DateUtil;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	
	import app.model.dict.RopewayDict;
	import app.model.vo.InchHistoryVO;
	import app.model.vo.InchVO;
	
	import custom.other.CustomUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class InchHistoryProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "InchHistoryProxy";
		
		public function InchHistoryProxy()
		{
			super(NAME, new Dictionary);
			
			for each(var rw:RopewayDict in RopewayDict.dict)
			{
				dict[rw] = new InchHistoryVO;
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
			var inch:InchVO = new InchVO;
			inch.date = DateUtil.addDateTime('m',-5, new Date);
			inch.humi = 50;
			inch.temp = 25;
			inch.value = 500;
			
			for each(var item:InchHistoryVO in dict)
			{
				item.UnshiftInch(inch);
			}
		}
		
		public function AddInch(rw:RopewayDict,inch:InchVO):void
		{
			var inchHistory:InchHistoryVO = dict[rw];
			inchHistory.PushInch(inch);
		}
	}
}