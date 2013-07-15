package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	
	import com.adobe.utils.DateUtil;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class RopewayForceProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayForceProxy";
		
		public function RopewayForceProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get col():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function GetForceHistory(dateS:Date,dateE:Date,station:String,ropewayId:String,tempMin:String,tempMax:String):AsyncToken
		{
			var where:String = "";
			where = "DeteDate >= '" + DateUtil.toLocaleW3CDTF(dateS) 
				+ "' AND DeteDate < '" + DateUtil.toLocaleW3CDTF(dateE) + "'";
			
			if(station != "所有索道站")
				where += " AND FromRopeStation = '" + station + "'";
			
			if(ropewayId != "所有抱索器")
				where += " AND RopeCode = '" + ropewayId + "'";
			
			if(tempMin != "")
				where += " AND Temperature >= " + Number(tempMin);
			
			if(tempMax != "")
				where += " AND Temperature <= " + Number(tempMax);
			
			return send("RopeDeteValueHis_GetList",onGetForceHistory,where);
		}
		
		private function onGetForceHistory(event:ResultEvent):void
		{			
			var arr:Array = [];
			for each(var o:ObjectProxy in event.result)
			{
				arr.push(new RopewayForceVO(o));
			}
			this.col.source = arr;
		}
	}
}