package app.model
{
	import app.model.vo.RopewaySwitchFreqVO;
	
	import com.adobe.utils.DateUtil;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectProxy;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class RopewaySwitchFreqProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewaySwitchFreqProxy";
		
		public function RopewaySwitchFreqProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get colSwitchFreq():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function GetSwitchFreqCol(dateS:Date,dateE:Date,station:String,ropewayId:String,type:Number):AsyncToken
		{
			var where:String = "";
			where = "RecordDate >= '" + DateUtil.toLocaleW3CDTF(dateS) 
				+ "' AND RecordDate < '" + DateUtil.toLocaleW3CDTF(dateE) + "'";
			
			if(station != "所有索道站")
				where += " AND FromRopeStation = '" + station + "'";
			
			if(ropewayId != "所有抱索器")
				where += " AND RopeCode = '" + ropewayId + "'";
			
			if(type == 0)
			{
				return send("RopeDete_RopeSwitchFreqDay_GetList",onGetSwitchFreqCol,where);
			}
			else if(type == 1)
			{
				return send("RopeDete_RopeSwitchFreqMonth_GetList",onGetSwitchFreqCol,where);
			}
			else
			{
				return null;
			}
		}
		
		private function onGetSwitchFreqCol(event:ResultEvent):void
		{			
			var arr:Array = [];
			for each(var o:ObjectProxy in event.result)
			{
				arr.push(new RopewaySwitchFreqVO(o));
			}
			this.colSwitchFreq.source = arr;
		}
	}
}