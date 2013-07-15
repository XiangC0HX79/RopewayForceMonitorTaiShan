package app.model
{
	import app.model.vo.RopewaySwitchFreqTotalVO;
	
	import com.adobe.utils.DateUtil;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class RopewaySwitchFreqTotalProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewaySwitchFreqTotalProxy";
		
		public function RopewaySwitchFreqTotalProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get colSwitchFreq():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function GetSwitchFreqCol(dateS:Date,dateE:Date,station:String,statis:Boolean):AsyncToken
		{
			var where:String = "";
			if(statis)
			{
				where = "RecordDate >= '" + DateUtil.toLocaleW3CDTF(dateS) 
					+ "' AND RecordDate < '" + DateUtil.toLocaleW3CDTF(dateE)
					+ "' AND FromRopeStation = '" + station + "'";
				
				return send("RopeDete_RopeSwitchFreqTotal_GetList",onGetSwitchFreqCol,where);
			}
			else
			{
				where += "FromRopeStation = '" + station + "'";
				
				return send("RopeDete_RopeSwitchFreqTotal_GetAllList",onGetSwitchFreqCol,where);
			}
		}
		
		private function onGetSwitchFreqCol(event:ResultEvent):void
		{			
			var arr:Array = [];
			for each(var o:ObjectProxy in event.result)
			{
				arr.push(new RopewaySwitchFreqTotalVO(o));
			}
			this.colSwitchFreq.source = arr;
		}
	}
}