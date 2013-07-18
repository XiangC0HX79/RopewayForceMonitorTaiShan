package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayVO;
	import app.view.components.ContentTodayOverview;
	
	import custom.itemRenderer.ItemRendererTodayOverview;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ISort;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.collections.Sort;
	
	public class ContentTodayOverviewMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentTodayOverviewMediator";
		
		public function ContentTodayOverviewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get contentTodayOverview():ContentTodayOverview
		{
			return viewComponent as ContentTodayOverview;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE,
				ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:	
					var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
					
					var dp:ArrayCollection = new ArrayCollection;
					
					for each(var r:RopewayVO in proxy.colRopeway)
					{
						dp.addItem(r);
					}
					
					dp.source.sortOn("ropewayCarId",Array.NUMERIC);
					
					contentTodayOverview.colDp = dp;
					break;
				
				case ApplicationFacade.NOTIFY_ROPEWAY_INFO_REALTIME:
					var rw:RopewayVO = notification.getBody() as RopewayVO;
					if(!contentTodayOverview.colDp.contains(rw))
					{
						contentTodayOverview.colDp.addItem(rw);
					}
					contentTodayOverview.colDp.source.sortOn("ropewayCarId",Array.NUMERIC);
					contentTodayOverview.colDp.refresh();
					break;
			}
		}
	}
}