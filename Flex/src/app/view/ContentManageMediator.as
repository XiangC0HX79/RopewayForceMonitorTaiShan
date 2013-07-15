package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayBaseinfoProxy;
	import app.model.RopewayForceProxy;
	import app.model.RopewayProxy;
	import app.model.vo.RopewayBaseinfoVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayNumTotelAnaVO;
	import app.model.vo.RopewayVO;
	import app.view.components.PanelAnalysisForce;
	import app.view.components.ContentAnalysis;
	import app.view.components.ContentManage;
	
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
	
	public class ContentManageMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentManageMediator";
		public function ContentManageMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			contentManage.addEventListener(FlexEvent.CREATION_COMPLETE,onCreation);
		}
		
		protected function get contentManage():ContentManage
		{
			return viewComponent as ContentManage;
		}
		
		private function onCreation(event:FlexEvent):void
		{
			contentManage.addbn.addEventListener(FlexEvent.BUTTON_DOWN,onadd);
			contentManage.editbn.addEventListener(FlexEvent.BUTTON_DOWN,onedit);
			contentManage.deletebn.addEventListener(FlexEvent.BUTTON_DOWN,ondelete);
			contentManage.datagrid.addEventListener(GridSelectionEvent.SELECTION_CHANGE,onselect);
			var arr:ArrayCollection = new ArrayCollection();
			var forceProxy:RopewayBaseinfoProxy = facade.retrieveProxy(RopewayBaseinfoProxy.NAME) as RopewayBaseinfoProxy;
			arr = forceProxy.update();
			contentManage.datagrid.dataProvider = arr;
		}
		
		private function onselect(event:GridSelectionEvent):void
		{
			if(contentManage.datagrid.selectedItem != null)
			{
				contentManage.ForceId.text = contentManage.datagrid.selectedItem.ropewayId;
				contentManage.CarId.text = contentManage.datagrid.selectedItem.carId;
				contentManage.RfId.text = contentManage.datagrid.selectedItem.rfId;
				contentManage.RopewayStation.text = contentManage.datagrid.selectedItem.ropewayStation;
			}
		}
		
		private function onadd(event:FlexEvent):void
		{
			if(contentManage.ForceId.text == ""||contentManage.CarId.text == ""
				||contentManage.RfId.text == ""||contentManage.RopewayStation.text == "")
			{
				Alert.show("缺少必要信息","提示");
				return;
			}
			var arr:ArrayCollection = new ArrayCollection();
			for each(var rb:RopewayBaseinfoVO in contentManage.datagrid.dataProvider)
			{
				arr.addItem(rb);
			}
			var rb2:RopewayBaseinfoVO = new RopewayBaseinfoVO;
			rb2.ropewayId = contentManage.ForceId.text;
			rb2.carId = contentManage.CarId.text;
			rb2.rfId = contentManage.RfId.text;
			rb2.ropewayStation = contentManage.RopewayStation.text;
			arr.addItem(rb2);
			contentManage.datagrid.dataProvider = arr;
			var forceProxy:RopewayBaseinfoProxy = facade.retrieveProxy(RopewayBaseinfoProxy.NAME) as RopewayBaseinfoProxy;
			forceProxy.adddata();
		}
		
		private function onedit(event:FlexEvent):void
		{
			if(contentManage.datagrid.selectedItem == null)
			{
				Alert.show("请选择一个设备","提示");
				return;
			}
			var arr:ArrayCollection = new ArrayCollection();
			for each(var rb:RopewayBaseinfoVO in contentManage.datagrid.dataProvider)
			{
				arr.addItem(rb);
			}
			arr[contentManage.datagrid.selectedIndex].ropewayId = contentManage.ForceId.text;
			arr[contentManage.datagrid.selectedIndex].carId = contentManage.CarId.text;
			arr[contentManage.datagrid.selectedIndex].rfId = contentManage.RfId.text;
			arr[contentManage.datagrid.selectedIndex].ropewayStation = contentManage.RopewayStation.text;
			contentManage.datagrid.dataProvider = arr;
			var forceProxy:RopewayBaseinfoProxy = facade.retrieveProxy(RopewayBaseinfoProxy.NAME) as RopewayBaseinfoProxy;
			forceProxy.editdata();
		}
		
		private function ondelete(event:FlexEvent):void
		{
			if(contentManage.datagrid.selectedItem == null)
			{
				Alert.show("请选择一个设备","提示");
				return;
			}
			var arr:ArrayCollection = new ArrayCollection();
			for each(var rb:RopewayBaseinfoVO in contentManage.datagrid.dataProvider)
			{
				arr.addItem(rb);
			}
			arr.removeItemAt(contentManage.datagrid.selectedIndex);
			contentManage.datagrid.dataProvider = arr;
			var forceProxy:RopewayBaseinfoProxy = facade.retrieveProxy(RopewayBaseinfoProxy.NAME) as RopewayBaseinfoProxy;
			forceProxy.deletedata();
		}
		
		private function onupdate():void
		{
			
		}
	}
}