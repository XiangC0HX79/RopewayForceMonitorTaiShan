package app.model
{
	import app.ApplicationFacade;
	import app.model.vo.StandVO;
	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class StandProxy extends Proxy
	{
		public static const NAME:String = "StandProxy";
		
		public function StandProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, new Dictionary);
		}
		
		public function get wheelDict():Dictionary
		{
			return data as Dictionary;
		}
		
		public function InitStandData(station:String):void
		{
			var now:Date = new Date;
			
			var s:StandVO  = new StandVO();
			var arr:ArrayCollection = new ArrayCollection();
			
			s.StandName = "支架";
			s.x = 20;
			s.y = 200;
			
			arr.addItem(s);
			s.StandName = "支架";
			s.x = 300;
			s.y = 200;
			
			arr.addItem(s);/*
			s.StandName = "支架";
			s.x = 600;
			s.y = 200;
			
			arr.addItem(s);*/
			
			sendNotification(ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE,arr);
		}
	}
}