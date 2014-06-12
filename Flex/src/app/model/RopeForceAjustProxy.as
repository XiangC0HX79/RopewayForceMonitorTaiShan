package app.model
{
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import app.model.dict.RopewayStationDict;
	import app.model.vo.RopeForceAjustVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class RopeForceAjustProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopeForceAjustProxy";
		
		public function RopeForceAjustProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get colRopeForceAjust():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function GetRopeForceAjustCol(station:RopewayStationDict):AsyncToken
		{
			var where:String = "FromRopeStation = '" + station.fullName + "'";
			return send("RopeDete_RopeCheck_GetList",onGetRopeForceCol,where);
		}
		
		private function onGetRopeForceCol(event:ResultEvent):void
		{
			var source:Array = [];
			for each(var o:* in event.result)
			{
				source.push(new RopeForceAjustVO(o));
			}
			colRopeForceAjust.source = source;
		}
		
		public function NewRopeForceAjust(station:RopewayStationDict,adjustDate:Date):AsyncToken
		{
			var ajust:RopeForceAjustVO = new RopeForceAjustVO({});
			ajust.ropewayStation = station;
			ajust.ropeway = station.ropeway;
			ajust.checkDatetime = adjustDate;
			ajust.lastUpdateDatetime = new Date;
			ajust.lastUpdateUser = "";
			
			var token:AsyncToken = send("RopeDete_RopeCheck_New",onNewRopeForce,ajust.toString());
			token.ajust = ajust;
			return token;
		}
		
		private function onNewRopeForce(event:ResultEvent):void
		{
			colRopeForceAjust.addItem(event.token.ajust);
		}
	}
}