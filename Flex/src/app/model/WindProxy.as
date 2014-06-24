package app.model
{
	import mx.collections.ArrayCollection;
	
	import app.ApplicationFacade;
	import app.model.vo.BracketVO;
	import app.model.vo.WindVO;
	import app.model.vo.WindValueVO;
	
	import org.puremvc.as3.multicore.patterns.proxy.Proxy;
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	public class WindProxy extends Proxy implements ILoadupProxy
	{
		public static const NAME:String = "WindProxy";
		public static const SRNAME:String = "WindProxySR";
		
		public function WindProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get list():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function load():void
		{
			list.removeAll();
			
			sendNotification(ApplicationFacade.NOTIFY_WIND_LOADED,NAME);
		}
		
		public function AddItem(bracket:BracketVO,windValue:WindValueVO):void
		{
			var wind:WindVO = retrieveWind(bracket);
			
			if(!wind)
			{
				wind = new WindVO(bracket);
				list.addItem(wind);
			}
			
			wind.PushInch(windValue);					
		}
		
		public function retrieveWind(bracket:BracketVO):WindVO
		{			
			for each(var item:WindVO in list)
			{
				if((item.bracket.ropeway.fullName == bracket.ropeway.fullName)
					&& (item.bracket.bracketId == bracket.bracketId))
				{
					return item;
				}
			}
			
			return null;
		}
	}
}