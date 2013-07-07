package app.view
{
	import app.ApplicationFacade;
	import app.model.RopewayForceProxy;
	import app.model.RopewayNumAnaProxy;
	import app.model.RopewayNumTotelAnaProxy;
	import app.model.RopewayProxy;
	import app.model.RopewayWarningAnaProxy;
	import app.model.vo.RopewayDayAveVO;
	import app.model.vo.RopewayForceVO;
	import app.model.vo.RopewayNumAnaVO;
	import app.model.vo.RopewayNumTotelAnaVO;
	import app.model.vo.RopewayVO;
	import app.view.components.Anacomponents.ropewayForceAna;
	import app.view.components.Anacomponents.ropewayNumAna;
	import app.view.components.Anacomponents.ropewayNumTotelAna;
	import app.view.components.Anacomponents.ropewayWarningAna;
	import app.view.components.ContentAnalysis;
	
	import custom.itemRenderer.ItemRendererTodayOverview;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.RadioButton;
	import spark.components.RadioButtonGroup;
	
	public class ContentAnalysisMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ContentAnalysisMediator";
		
		public function ContentAnalysisMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			contentAnalysis.addEventListener(FlexEvent.CREATION_COMPLETE,onCreation)
		}
		
		protected function get contentAnalysis():ContentAnalysis
		{
			return viewComponent as ContentAnalysis;
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
			}
		}
		
		private function onCreation(event:FlexEvent):void
		{
			contentAnalysis.RopewayForceAna.submitbn.addEventListener(FlexEvent.BUTTON_DOWN,onForceSubmit);
			contentAnalysis.RopewayForceAna.rbGroup3.addEventListener(Event.CHANGE,ChangeHandle,false,0);
			contentAnalysis.RopewayNumAna.addEventListener(FlexEvent.UPDATE_COMPLETE,numUpdated);
			contentAnalysis.RopewayNumTotelAna.addEventListener(FlexEvent.UPDATE_COMPLETE,TotelUpdated);
			contentAnalysis.RopewayWarningAna.addEventListener(FlexEvent.UPDATE_COMPLETE,WarningUpdated);
		}
		
		private function onForceSubmit(event:FlexEvent):void
		{
			var fromDates:Array;
			var fromDate:Date;
			var toDates:Array;
			var toDate:Date;
			var obj:Object = new Object();
			obj.TYPE = contentAnalysis.RopewayForceAna.vs1.selectedIndex;
			if(obj.TYPE == 0)
			{
				fromDates=contentAnalysis.RopewayForceAna.dateFrom1.text.split("-");
				fromDate=new Date(Number(fromDates[0]),Number(fromDates[1]),Number(fromDates[2]),Number(contentAnalysis.RopewayForceAna.numericStepper1.value));
				toDates=contentAnalysis.RopewayForceAna.dateFrom1.text.split("-");
				toDate=new Date(Number(toDates[0]),Number(toDates[1]),Number(toDates[2]),Number(contentAnalysis.RopewayForceAna.numericStepper2.value));
			}
			else if(obj.TYPE == 1)
			{
				fromDates=contentAnalysis.RopewayForceAna.dateFrom2.text.split("-");
				fromDate=new Date(Number(fromDates[0]),Number(fromDates[1]),Number(fromDates[2]),0);
				toDates=contentAnalysis.RopewayForceAna.dateTo2.text.split("-");
				toDate=new Date(Number(toDates[0]),Number(toDates[1]),Number(toDates[2]),0);
			}
			else
			{
				fromDates=contentAnalysis.RopewayForceAna.dateFrom3.text.split("-");
				fromDate=new Date(Number(fromDates[0]),Number(fromDates[1]),1,0);
				toDates=contentAnalysis.RopewayForceAna.dateTo3.text.split("-");
				toDate=new Date(Number(toDates[0]),Number(toDates[1]),1,0);
			}
			if(fromDate.time>=toDate.time || fromDates.length < 2 || toDates.length < 2)
			{
				Alert.show("选择时间错误","提示");
				return;
			}
			obj.RESULTTYPE = contentAnalysis.RopewayForceAna.vs2.selectedIndex;
			obj.FROMDATE = fromDate;
			obj.TODATE = toDate;
			if(contentAnalysis.RopewayForceAna.vs2.selectedIndex == 0)
			{
				if(contentAnalysis.RopewayForceAna.ForceId.text == "")
				{
					Alert.show("请输入索道编号","提示");
					return;
				}
			}
			obj.ID = contentAnalysis.RopewayForceAna.ForceId.text;
			obj.LOWTEMP = contentAnalysis.RopewayForceAna.lowtemp.text;
			obj.HIGHTEMP = contentAnalysis.RopewayForceAna.hightemp.text;
			obj.STATION = "";
			if(contentAnalysis.RopewayForceAna.cb1.selected == true&&contentAnalysis.RopewayForceAna.cb2.selected == true
				&&contentAnalysis.RopewayForceAna.cb3.selected == true&&contentAnalysis.RopewayForceAna.cb4.selected == true)
			{
				
			}
			else if(contentAnalysis.RopewayForceAna.cb1.selected == false&&contentAnalysis.RopewayForceAna.cb2.selected == false
				&&contentAnalysis.RopewayForceAna.cb3.selected == false&&contentAnalysis.RopewayForceAna.cb4.selected == false)
			{
				Alert.show("必须选择一个站","提示");
				return;
			}
			else
			{
				if(contentAnalysis.RopewayForceAna.cb1.selected == true)
					obj.STATION += "," + contentAnalysis.RopewayForceAna.cb1.label;
				if(contentAnalysis.RopewayForceAna.cb2.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayForceAna.cb2.label;
				if(contentAnalysis.RopewayForceAna.cb3.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayForceAna.cb3.label;
				if(contentAnalysis.RopewayForceAna.cb4.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayForceAna.cb4.label;
			}
			
			var arr:ArrayCollection = new ArrayCollection();
			var forceProxy:RopewayForceProxy = facade.retrieveProxy(RopewayForceProxy.NAME) as RopewayForceProxy;
			if(obj.TYPE == 0)
				arr = forceProxy.GetForce(obj);
			else if(obj.TYPE == 1)
				arr = forceProxy.GetDayAve(obj);
			else if(obj.TYPE == 2)
				arr = forceProxy.GetMonthAve(obj);
			if(obj.RESULTTYPE == 0)
				contentAnalysis.RopewayForceAna.linechart1.dataProvider = arr;
			else if(obj.RESULTTYPE == 1)
			{
				contentAnalysis.RopewayForceAna.datagrid1.dataProvider = arr;
			}
			else
				contentAnalysis.RopewayForceAna.datagrid2.dataProvider = arr;
				
		}
		
		private var arrC:ArrayCollection
		private var num:int
		private function ChangeHandle(event:Event):void
		{
			arrC = new ArrayCollection;
			num = 0;
			var ra:RadioButtonGroup = event.currentTarget as RadioButtonGroup;
			if(ra.selectedValue.toString() == "明细查询") 
			{
				if(contentAnalysis.RopewayForceAna.rbGroup1.selectedValue.toString() == "按时间段")
				{
					if(contentAnalysis.RopewayForceAna.linechart1.dataProvider!=null)
					{
						for each(var r:RopewayForceVO in  contentAnalysis.RopewayForceAna.linechart1.dataProvider)
						arrC.addItem(r);
						contentAnalysis.RopewayForceAna.vs2.addEventListener(FlexEvent.UPDATE_COMPLETE,PushData);
						num = 1;
					}
				}
				else
				{
					if(contentAnalysis.RopewayForceAna.linechart1.dataProvider!=null)
					{
						for each(var rd:RopewayDayAveVO in  contentAnalysis.RopewayForceAna.linechart1.dataProvider)
						arrC.addItem(rd);
						contentAnalysis.RopewayForceAna.vs2.addEventListener(FlexEvent.UPDATE_COMPLETE,PushData);
						num = 2;
					}
					
				}
			}
			else
			{
				
				if(contentAnalysis.RopewayForceAna.rbGroup1.selectedValue.toString() == "按时间段")
				{
					
					if(contentAnalysis.RopewayForceAna.datagrid1.dataProvider!=null)
					{
						if(contentAnalysis.RopewayForceAna.ForceId.text == ""&&contentAnalysis.RopewayForceAna.datagrid1.dataProvider.length != 0)
						{
							num = 2
							contentAnalysis.RopewayForceAna.vs2.addEventListener(FlexEvent.UPDATE_COMPLETE,enPushData);
						}
						else
						{
							for each(var r2:RopewayForceVO in  contentAnalysis.RopewayForceAna.datagrid1.dataProvider)
								arrC.addItem(r2);
							contentAnalysis.RopewayForceAna.vs2.addEventListener(FlexEvent.UPDATE_COMPLETE,enPushData);
							num = 1;
						}
					}
				}
				else
				{
					
					if(contentAnalysis.RopewayForceAna.datagrid2.dataProvider!=null)
					{
						if(contentAnalysis.RopewayForceAna.ForceId.text == ""&&contentAnalysis.RopewayForceAna.datagrid2.dataProvider.length != 0)
						{
							num = 2
							contentAnalysis.RopewayForceAna.vs2.addEventListener(FlexEvent.UPDATE_COMPLETE,enPushData);
						}
						else
						{
							for each(var rd2:RopewayDayAveVO in  contentAnalysis.RopewayForceAna.datagrid2.dataProvider)
							arrC.addItem(rd2);
							contentAnalysis.RopewayForceAna.vs2.addEventListener(FlexEvent.UPDATE_COMPLETE,enPushData);
							num = 1;
						}
					}
					
				}
			}
		}
		
		private function PushData(event:FlexEvent):void
		{
			if(num == 1)
				contentAnalysis.RopewayForceAna.datagrid1.dataProvider = arrC;
			if(num == 2)
				contentAnalysis.RopewayForceAna.datagrid2.dataProvider = arrC;
			contentAnalysis.RopewayForceAna.vs2.removeEventListener(FlexEvent.UPDATE_COMPLETE,PushData);
			num = 0;
		}
		
		private function enPushData(event:FlexEvent):void
		{
			if(num == 1)
				contentAnalysis.RopewayForceAna.linechart1.dataProvider = arrC;
			if(num == 2)
			{
				contentAnalysis.RopewayForceAna.linechart1.dataProvider = null;
				Alert.show("必须输入索道编号","提示");
			}
			contentAnalysis.RopewayForceAna.vs2.removeEventListener(FlexEvent.UPDATE_COMPLETE,enPushData);
			num = 0;
		}
		
		private function numUpdated(event:FlexEvent):void
		{
			if(contentAnalysis.TabN.selectedIndex == 1)
			{
				contentAnalysis.RopewayNumAna.submitbn.addEventListener(FlexEvent.BUTTON_DOWN,onNumAna);
				contentAnalysis.RopewayNumAna.rbGroup3.addEventListener(Event.CHANGE,numChangeHandle,false,0);
			}
		}
		
		private function onNumAna(event:FlexEvent):void
		{
			var fromDates:Array;
			var fromDate:Date;
			var toDates:Array;
			var toDate:Date;
			var obj:Object = new Object();
			obj.TYPE = contentAnalysis.RopewayNumAna.vs1.selectedIndex;
			if(obj.TYPE == 0)
			{
				fromDates=contentAnalysis.RopewayNumAna.dateFrom2.text.split("-");
				fromDate=new Date(Number(fromDates[0]),Number(fromDates[1]),Number(fromDates[2]),0);
				toDates=contentAnalysis.RopewayNumAna.dateTo2.text.split("-");
				toDate=new Date(Number(toDates[0]),Number(toDates[1]),Number(toDates[2]),0);
			}
			else
			{
				fromDates=contentAnalysis.RopewayNumAna.dateFrom3.text.split("-");
				fromDate=new Date(Number(fromDates[0]),Number(fromDates[1]),1,0);
				toDates=contentAnalysis.RopewayNumAna.dateTo3.text.split("-");
				toDate=new Date(Number(toDates[0]),Number(toDates[1]),1,0);
			}
			if(fromDate.time>=toDate.time || fromDates.length < 2 || toDates.length < 2)
			{
				Alert.show("选择时间错误","提示");
				return;
			}
			obj.RESULTTYPE = contentAnalysis.RopewayNumAna.vs2.selectedIndex;
			obj.FROMDATE = fromDate;
			obj.TODATE = toDate;
			if(contentAnalysis.RopewayNumAna.vs2.selectedIndex == 0)
			{
				if(contentAnalysis.RopewayNumAna.ForceId.text == "")
				{
					Alert.show("请输入索道编号","提示");
					return;
				}
			}
			obj.ID = contentAnalysis.RopewayNumAna.ForceId.text;
			obj.STATION = "";
			if(contentAnalysis.RopewayNumAna.cb1.selected == true&&contentAnalysis.RopewayNumAna.cb2.selected == true
				&&contentAnalysis.RopewayNumAna.cb3.selected == true&&contentAnalysis.RopewayNumAna.cb4.selected == true)
			{
				
			}
			else if(contentAnalysis.RopewayNumAna.cb1.selected == false&&contentAnalysis.RopewayNumAna.cb2.selected == false
				&&contentAnalysis.RopewayNumAna.cb3.selected == false&&contentAnalysis.RopewayNumAna.cb4.selected == false)
			{
				Alert.show("必须选择一个站","提示");
				return;
			}
			else
			{
				if(contentAnalysis.RopewayNumAna.cb1.selected == true)
					obj.STATION += "," + contentAnalysis.RopewayNumAna.cb1.label;
				if(contentAnalysis.RopewayNumAna.cb2.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayNumAna.cb2.label;
				if(contentAnalysis.RopewayNumAna.cb3.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayNumAna.cb3.label;
				if(contentAnalysis.RopewayNumAna.cb4.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayNumAna.cb4.label;
			}
			
			var arr:ArrayCollection = new ArrayCollection();
			var forceProxy:RopewayNumAnaProxy = facade.retrieveProxy(RopewayNumAnaProxy.NAME) as RopewayNumAnaProxy;
			if(obj.TYPE == 0)
				arr = forceProxy.GetDayNum(obj);
			else if(obj.TYPE == 1)
				arr = forceProxy.GetMonthNum(obj);
			if(obj.RESULTTYPE == 0)
				contentAnalysis.RopewayNumAna.linechart1.dataProvider = arr;
			else if(obj.RESULTTYPE == 1)
			{
				contentAnalysis.RopewayNumAna.datagrid.dataProvider = arr;
			}
		}
		private function numChangeHandle(event:Event):void
		{
			arrC = new ArrayCollection;
			num = 0;
			var ra:RadioButtonGroup = event.currentTarget as RadioButtonGroup;
			if(ra.selectedValue.toString() == "明细查询") 
			{
				if(contentAnalysis.RopewayNumAna.linechart1.dataProvider!=null)
				{
					for each(var rd:RopewayNumAnaVO in  contentAnalysis.RopewayNumAna.linechart1.dataProvider)
					arrC.addItem(rd);
					contentAnalysis.RopewayNumAna.vs2.addEventListener(FlexEvent.UPDATE_COMPLETE,numPushData);
					num = 2;
				}
			}
			else
			{
				if(contentAnalysis.RopewayNumAna.datagrid.dataProvider!=null)
				{
					if(contentAnalysis.RopewayNumAna.ForceId.text == ""&&contentAnalysis.RopewayNumAna.datagrid.dataProvider.length != 0)
					{
						num = 2
						contentAnalysis.RopewayNumAna.vs2.addEventListener(FlexEvent.UPDATE_COMPLETE,numenPushData);
					}
					else
					{
						for each(var rd2:RopewayNumAnaVO in  contentAnalysis.RopewayNumAna.datagrid.dataProvider)
						arrC.addItem(rd2);
						contentAnalysis.RopewayNumAna.vs2.addEventListener(FlexEvent.UPDATE_COMPLETE,numenPushData);
						num = 1;
					}
				}
			}
		}
		
		private function numPushData(event:FlexEvent):void
		{
			if(num == 1)
				contentAnalysis.RopewayNumAna.datagrid.dataProvider = arrC;
			if(num == 2)
				contentAnalysis.RopewayNumAna.datagrid.dataProvider = arrC;
			contentAnalysis.RopewayNumAna.vs2.removeEventListener(FlexEvent.UPDATE_COMPLETE,numPushData);
			num = 0;
		}
		
		private function numenPushData(event:FlexEvent):void
		{
			if(num == 1)
				contentAnalysis.RopewayNumAna.linechart1.dataProvider = arrC;
			if(num == 2)
			{
				contentAnalysis.RopewayNumAna.linechart1.dataProvider = null;
				Alert.show("必须输入索道编号","提示");
			}
			contentAnalysis.RopewayNumAna.vs2.removeEventListener(FlexEvent.UPDATE_COMPLETE,numenPushData);
			num = 0;
		}
		
		private function TotelUpdated(event:FlexEvent):void
		{
			if(contentAnalysis.TabN.selectedIndex == 2)
			{
				//contentAnalysis.RopewayNumTotelAna.legend.dataProvider = contentAnalysis.RopewayNumTotelAna.columnchart1;
				contentAnalysis.RopewayNumTotelAna.submitbn.addEventListener(FlexEvent.BUTTON_DOWN,onTotelAna);
				contentAnalysis.RopewayNumTotelAna.rbGroup3.addEventListener(Event.CHANGE,totelChangeHandle,false,0);
			}
		}
		
		private function onTotelAna(event:FlexEvent):void
		{
			var obj:Object = new Object();
			obj.RESULTTYPE = contentAnalysis.RopewayNumTotelAna.vs2.selectedIndex;
			obj.ID = contentAnalysis.RopewayNumTotelAna.ForceId.text;
			obj.STATION = "";
			if(contentAnalysis.RopewayNumTotelAna.cb1.selected == true&&contentAnalysis.RopewayNumTotelAna.cb2.selected == true
				&&contentAnalysis.RopewayNumTotelAna.cb3.selected == true&&contentAnalysis.RopewayNumTotelAna.cb4.selected == true)
			{
				
			}
			else if(contentAnalysis.RopewayNumTotelAna.cb1.selected == false&&contentAnalysis.RopewayNumTotelAna.cb2.selected == false
				&&contentAnalysis.RopewayNumTotelAna.cb3.selected == false&&contentAnalysis.RopewayNumTotelAna.cb4.selected == false)
			{
				Alert.show("必须选择一个站","提示");
				return;
			}
			else
			{
				if(contentAnalysis.RopewayNumTotelAna.cb1.selected == true)
					obj.STATION += "," + contentAnalysis.RopewayNumTotelAna.cb1.label;
				if(contentAnalysis.RopewayNumTotelAna.cb2.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayNumTotelAna.cb2.label;
				if(contentAnalysis.RopewayNumTotelAna.cb3.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayNumTotelAna.cb3.label;
				if(contentAnalysis.RopewayNumTotelAna.cb4.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayNumTotelAna.cb4.label;
			}
			
			var arr:ArrayCollection = new ArrayCollection();
			var forceProxy:RopewayNumTotelAnaProxy = facade.retrieveProxy(RopewayNumTotelAnaProxy.NAME) as RopewayNumTotelAnaProxy;
			arr = forceProxy.GetTotel(obj);
			if(obj.RESULTTYPE == 0)
				contentAnalysis.RopewayNumTotelAna.columnchart1.dataProvider = arr;
			else if(obj.RESULTTYPE == 1)
			{
				contentAnalysis.RopewayNumTotelAna.datagrid.dataProvider = arr;
			}
		}
		private function totelChangeHandle(event:Event):void
		{
			arrC = new ArrayCollection;
			num = 0;
			var ra:RadioButtonGroup = event.currentTarget as RadioButtonGroup;
			if(ra.selectedValue.toString() == "明细查询") 
			{
				if(contentAnalysis.RopewayNumTotelAna.columnchart1.dataProvider!=null)
				{
					for each(var rd:Object in  contentAnalysis.RopewayNumTotelAna.columnchart1.dataProvider)
					arrC.addItem(rd);
					contentAnalysis.RopewayNumTotelAna.vs2.addEventListener(FlexEvent.UPDATE_COMPLETE,totelPushData);
					num = 2;
				}
			}
			else
			{
				if(contentAnalysis.RopewayNumTotelAna.datagrid.dataProvider!=null)
				{
					
					for each(var rd2:Object in  contentAnalysis.RopewayNumTotelAna.datagrid.dataProvider)
					arrC.addItem(rd2);
					contentAnalysis.RopewayNumTotelAna.vs2.addEventListener(FlexEvent.UPDATE_COMPLETE,totelenPushData);
					num = 1;
				}
			}
		}
		
		private function totelPushData(event:FlexEvent):void
		{
			if(num == 1)
				contentAnalysis.RopewayNumTotelAna.datagrid.dataProvider = arrC;
			if(num == 2)
				contentAnalysis.RopewayNumTotelAna.datagrid.dataProvider = arrC;
			contentAnalysis.RopewayNumTotelAna.vs2.removeEventListener(FlexEvent.UPDATE_COMPLETE,totelPushData);
			num = 0;
		}
		
		private function totelenPushData(event:FlexEvent):void
		{
			contentAnalysis.RopewayNumTotelAna.columnchart1.dataProvider = arrC;
			contentAnalysis.RopewayNumTotelAna.vs2.removeEventListener(FlexEvent.UPDATE_COMPLETE,totelenPushData);
			num = 0;
		}
		
		private function WarningUpdated(event:FlexEvent):void
		{
			if(contentAnalysis.TabN.selectedIndex == 3)
			{
				contentAnalysis.RopewayWarningAna.submitbn.addEventListener(FlexEvent.BUTTON_DOWN,onWarningAna);
			}
		}
		
		private function onWarningAna(event:FlexEvent):void
		{
			var fromDates:Array;
			var fromDate:Date;
			var toDates:Array;
			var toDate:Date;
			var obj:Object = new Object();
			fromDates=contentAnalysis.RopewayWarningAna.dateFrom1.text.split("-");
			fromDate=new Date(Number(fromDates[0]),Number(fromDates[1]),Number(fromDates[2]),Number(contentAnalysis.RopewayWarningAna.numericStepper1.value));
			toDates=contentAnalysis.RopewayWarningAna.dateTo1.text.split("-");
			toDate=new Date(Number(toDates[0]),Number(toDates[1]),Number(toDates[2]),Number(contentAnalysis.RopewayWarningAna.numericStepper2.value));
			obj.FROMDATE = fromDate;
			obj.TODATE = toDate;
			obj.ID = contentAnalysis.RopewayWarningAna.ForceId.text;
			obj.STATION = "";
			if(contentAnalysis.RopewayWarningAna.cb1.selected == true&&contentAnalysis.RopewayWarningAna.cb2.selected == true
				&&contentAnalysis.RopewayWarningAna.cb3.selected == true&&contentAnalysis.RopewayWarningAna.cb4.selected == true)
			{
				
			}
			else if(contentAnalysis.RopewayWarningAna.cb1.selected == false&&contentAnalysis.RopewayWarningAna.cb2.selected == false
				&&contentAnalysis.RopewayWarningAna.cb3.selected == false&&contentAnalysis.RopewayWarningAna.cb4.selected == false)
			{
				Alert.show("必须选择一个站","提示");
				return;
			}
			else
			{
				if(contentAnalysis.RopewayWarningAna.cb1.selected == true)
					obj.STATION += "," + contentAnalysis.RopewayWarningAna.cb1.label;
				if(contentAnalysis.RopewayWarningAna.cb2.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayWarningAna.cb2.label;
				if(contentAnalysis.RopewayWarningAna.cb3.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayWarningAna.cb3.label;
				if(contentAnalysis.RopewayWarningAna.cb4.selected == true)
					obj.STATION += "," +  contentAnalysis.RopewayWarningAna.cb4.label;
			}
			
			var arr:ArrayCollection = new ArrayCollection();
			var forceProxy:RopewayWarningAnaProxy = facade.retrieveProxy(RopewayWarningAnaProxy.NAME) as RopewayWarningAnaProxy;
			arr = forceProxy.GetWarningInfo(obj);
			contentAnalysis.RopewayWarningAna.datagrid.dataProvider = arr;
		}
	}
}