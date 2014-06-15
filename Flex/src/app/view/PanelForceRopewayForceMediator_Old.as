package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.ConfigVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.PanelForceRopewayForce;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelForceRopewayForceMediator_Old extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelForceRopewayForceMediator";
		
		public function PanelForceRopewayForceMediator_Old(viewComponent:Object = null)
		{
			super(NAME, viewComponent);			
		}
		
		protected function get panelRopewayForce():PanelForceRopewayForce
		{
			return viewComponent as PanelForceRopewayForce;
		}
	}
}