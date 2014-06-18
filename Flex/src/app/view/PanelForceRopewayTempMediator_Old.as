package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.PanelForceRopewayTemp;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelForceRopewayTempMediator_Old extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelForceRopewayTempMediator";
		
		public function PanelForceRopewayTempMediator_Old(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get panelRopewayTemp():PanelForceRopewayTemp
		{
			return viewComponent as PanelForceRopewayTemp;
		}
	}
}