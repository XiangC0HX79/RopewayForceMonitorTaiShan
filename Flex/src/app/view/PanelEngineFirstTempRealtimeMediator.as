package app.view
{
	import com.adobe.utils.DateUtil;
	
	import app.ApplicationFacade;
	import app.model.EngineTempProxy;
	import app.model.dict.RopewayDict;
	import app.model.vo.EngineVO;
	import app.view.components.PanelEngineTempRealtime;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelEngineFirstTempRealtimeMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelEngineFirstTempRealtimeMediator";
		
		public function PanelEngineFirstTempRealtimeMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelEngineTempRealtime():PanelEngineTempRealtime
		{
			return viewComponent as PanelEngineTempRealtime;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{	
			switch(notification.getName())
			{
			}
		}		
	}
}