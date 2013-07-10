package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayVO;
	import app.view.components.ContentTodayOverview;
	
	import custom.itemRenderer.ItemRendererTodayOverview;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
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
				ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_ROPEWAY_COMPLETE:	
					var proxy:RopewayProxy = facade.retrieveProxy(RopewayProxy.NAME) as RopewayProxy;
					
					var dp:ArrayCollection = new ArrayCollection;
					
					for each(var r:RopewayVO in proxy.ropewayDict)
					{
						dp.addItem(r);
					}
					
					contentTodayOverview.colDp = dp;
					break;
			}
		}
	}
}