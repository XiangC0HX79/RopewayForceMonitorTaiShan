package app.model
{
	import app.model.vo.RopeForceAjustVO;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
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
		
		public function GetRopeForceAjustCol(station:String):AsyncToken
		{
			var where:String = "FromRopeStation = '" + station + "'";
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
		
		public function NewRopeForceAjust(station:String,adjustDate:Date):AsyncToken
		{
			var ajust:RopeForceAjustVO = new RopeForceAjustVO({});
			ajust.fromRopeStation = station;
			ajust.fromRoapWay = "";
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