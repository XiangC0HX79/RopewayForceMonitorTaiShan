package app.view
{
	import app.ApplicationFacade;
	import app.model.ConfigProxy;
	import app.model.CarriageEditHisProxy;
	import app.model.CarriageProxy;
	import app.model.RopewayForceProxy;
	import app.model.vo.CarriageVO;
	import app.model.vo.ForceVO;
	import app.model.vo.RopewayStationForceVO;
	import app.view.components.ContentForceAnalysis;
	import app.view.components.ContentForceManage;
	import app.view.components.PanelForceAnalysisForce;
	
	import com.adobe.utils.StringUtil;
	
	import custom.itemRenderer.ItemRendererTodayOverview;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.RadioButton;
	import spark.components.RadioButtonGroup;
	import spark.events.GridSelectionEvent;
	
	public class ContentForceManageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentForceManageMediator";
		
		public function ContentForceManageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			contentManage.viewStatck.addChild(facade.retrieveMediator(PanelForceManagerBaseInfoMediator.NAME).getViewComponent() as DisplayObject);
			contentManage.viewStatck.addChild(facade.retrieveMediator(PanelForceManagerAdjustMediator.NAME).getViewComponent() as DisplayObject);
		}
		
		protected function get contentManage():ContentForceManage
		{
			return viewComponent as ContentForceManage;
		}
	}
}