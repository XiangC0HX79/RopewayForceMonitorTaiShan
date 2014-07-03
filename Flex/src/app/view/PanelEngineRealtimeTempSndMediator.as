package app.view
{
	import com.adobe.utils.DateUtil;
	
	import app.ApplicationFacade;
	import app.model.EngineProxy;
	import app.model.vo.RopewayVO;
	import app.model.vo.EngineVO;
	import app.view.components.PanelEngineRealtimeTemp;
	
	import org.puremvc.as3.multicore.interfaces.IMediator;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.mediator.Mediator;
	
	public class PanelEngineRealtimeTempSndMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelEngineRealtimeTempSndMediator";
		
		public function PanelEngineRealtimeTempSndMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelEngineTempRealtime():PanelEngineRealtimeTemp
		{
			return viewComponent as PanelEngineRealtimeTemp;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.ACTION_UPDATE_ROPEWAY
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{	
			switch(notification.getName())
			{
				case ApplicationFacade.ACTION_UPDATE_ROPEWAY:
					panelEngineTempRealtime.engine = RopewayVO(notification.getBody()).engineSnd;	
					break;
			}
		}		
	}
}