package app.view
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import spark.effects.Move;
	
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.ChartImage;
	import app.view.components.PanelForceRopewayChart;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PanelForceRopewayChartMediator_Old extends Mediator implements IMediator
	{
		public static const NAME:String = "PanelForceRopewayChartMediator";
		
		public static const ONE_MIN:Number = 60 * 1000;
		public static const TEN_MIN:Number = 10 * 60 * 1000;
		public static const HALF_HOUR:Number = 30 * 60 * 1000;
		public static const ONE_HOUR:Number = 60 * 60 * 1000;
				
		public function PanelForceRopewayChartMediator_Old(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
		}
		
		protected function get chartRealtimeDetection():PanelForceRopewayChart
		{
			return viewComponent as PanelForceRopewayChart;
		}
	}
}