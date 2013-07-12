package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.RopewayDayAveVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayVO;
	
	import com.adobe.utils.DateUtil;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.formatters.DateFormatter;
	import mx.rpc.AsyncToken;
	import mx.utils.StringUtil;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class RopewayForceProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "RopewayForceProxy";
		
		public function RopewayForceProxy()
		{
			super(NAME, new Dictionary);
		}
		
		public function get ropewayDict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function GetForceHistory(dateS:Date,dateE:Date,station:String,ropewayId:String):AsyncToken
		{
			var where:String = "";
			where = "DeteDate >= '" + DateUtil.toW3CDTF(dateS) 
				+ "' AND DeteDate <= '" + DateUtil.toW3CDTF(dateE) + "'";
			
			if(station != "所有索道站")
				where = " AND FromRopeStation = '" + station + "'";
			
			if(ropewayId != "所有抱索器")
				where = " AND RopeCode = '" + ropewayId + "'";
			
			return send("RopeDeteInfoToday_GetList",null,where);
		}
		
		public function GetDayAve(obj:Object):ArrayCollection
		{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int;i<=30;i++)
			{
				var r:RopewayDayAveVO = new RopewayDayAveVO();	
				r.ropewayId = String(int(Math.random() * 100));		
				r.ropewayForce = int(Math.random() * 500);
				r.ropewayTime = new Date;
				r.ropewayStation = "桃花源"
				arr.addItem(r);
			}
			return arr;
		}
		
		public function GetMonthAve(obj:Object):ArrayCollection
		{
			var arr:ArrayCollection = new ArrayCollection();
			for(var i:int;i<=30;i++)
			{
				var r:RopewayDayAveVO = new RopewayDayAveVO();	
				r.ropewayId = String(int(Math.random() * 100));		
				r.ropewayForce = int(Math.random() * 500);
				r.ropewayTime = new Date;
				r.ropewayStation = "桃花源"
				arr.addItem(r);
			}
			return arr;
		}
	}
}