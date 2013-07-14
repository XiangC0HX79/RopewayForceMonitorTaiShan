package app.model
{
	import com.adobe.utils.DateUtil;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	
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
		
		public function GetForceAveCol(dateS:Date,dateE:Date,station:String,ropewayId:String):AsyncToken
		{
			var where:String = "";
			where = "RecordDate >= '" + DateUtil.toLocaleW3CDTF(dateS) 
				+ "' AND RecordDate <= '" + DateUtil.toLocaleW3CDTF(dateE) + "'";
			
			if(station != "所有索道站")
				where += " AND FromRopeStation = '" + station + "'";
			
			if(ropewayId != "所有抱索器")
				where += " AND RopeCode = '" + ropewayId + "'";
			
			return send("RopeDeteValueHis_GetList",null,where);
		}
	}
}