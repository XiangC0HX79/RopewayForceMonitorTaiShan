package app.model
{
	import app.model.vo.RopewayForceAverageVO;
	
	import com.adobe.utils.DateUtil;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RopewayForceAverageProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayForceAverageProxy";
		
		public function RopewayForceAverageProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get col():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function GetForceAveCol(dateS:Date,dateE:Date,station:String,ropewayId:String,type:Number):AsyncToken
		{
			var where:String = "";
			where = "MaxValue IS NOT NULL AND MinValue IS NOT NULL AND AverageValue IS NOT NULL "
				+ "AND RecordDate >= '" + DateUtil.toLocaleW3CDTF(dateS) 
				+ "' AND RecordDate < '" + DateUtil.toLocaleW3CDTF(dateE) + "'";
			
			if(station != "所有索道站")
				where += " AND FromRopeStation = '" + station + "'";
			
			if(ropewayId != "所有抱索器")
				where += " AND RopeCode = '" + ropewayId + "'";
			
			if(type == 0)
			{
				return send("RopeDete_RopeDeteValueAverageDay_GetList",onGetForceAveCol,where);
			}
			else if(type == 1)
			{
				return send("RopeDete_RopeDeteValueAverageMonth_GetList",onGetForceAveCol,where);
			}
			else
			{
				return null;
			}
		}
		
		private function onGetForceAveCol(event:ResultEvent):void
		{			
			var arr:Array = [];
			for each(var o:ObjectProxy in event.result)
			{
				arr.push(new RopewayForceAverageVO(o));
			}
			this.col.source = arr;
		}
	}
}