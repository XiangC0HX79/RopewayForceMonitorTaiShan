package app.model
{
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.vo.InternalVO;
	import app.model.vo.RopewayStationFstVO;
	import app.model.vo.RopewayStationSndVO;
	import app.model.vo.RopewayStationVO;
	import app.model.vo.RopewayVO;
	import app.model.vo.SurroundingVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	use namespace InternalVO; 
	
	public class RopewayStationProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String= "RopewayStationProxy";
		public static const SRNAME:String= "RopewayStationProxySR";
		
		public static const LOADED:String= "RopewayStationProxy/Loaded";
		public static const FAILED:String= "RopewayStationProxy/Failed";
		
		public function RopewayStationProxy()
		{
			super(NAME);
		}
		
		/*public function get list():ArrayCollection
		{			
			return new ArrayCollection(data as Array);
		}*/
		
		public function load():void
		{
			/*for each(var rw:RopewayVO in  RopewayProxy(facade.retrieveProxy(RopewayProxy.NAME)).list)
			{
				rw.stationFst = new RopewayStationFstVO(rw);
				rw.stationSnd = new RopewayStationSndVO(rw);
			}*/
							
			sendNotification(LOADED,NAME);
			
			//sendNotification(ApplicationFacade.ACTION_UPDATE_ROPEWAY_STATION,list);
		}
		
		public function updateSurrounding(rsName:String,date:Date,temp:Number,humi:Number):void
		{
			var sr:SurroundingVO = new SurroundingVO;			
			sr.temp = temp;
			sr.humi = humi;			
			sr.date = date;
			
			RopewayStationVO.getNamed(rsName).surrounding = sr;
		}
	}
}