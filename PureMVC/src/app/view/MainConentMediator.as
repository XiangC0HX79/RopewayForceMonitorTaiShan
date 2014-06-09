package app.view
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	
	import spark.components.Application;
	import spark.components.Image;
	
	import app.ApplicationFacade;
	import app.model.vo.AreaWheelVO;
	import app.model.vo.StandVO;
	import app.model.vo.WarnTypeVO;
	import app.model.vo.WheelManageVO;
	import app.model.vo.WheelVO;
	import app.view.components.AreaTitleWindow;
	import app.view.components.MainContent;
	import app.view.components.NumStatus;
	import app.view.components.TitleWindowStand;
	import app.view.components.contentcomponents.StandStation;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class MainConentMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "MainConentMediator";
		
		public function MainConentMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			mainContent.addEventListener(MainContent.WHEEL_DETECTION,onAdd);
			mainContent.addEventListener(MainContent.STAND_DETECTION,onStandAdd);
		}
		
		protected function get mainContent():MainContent
		{
			return viewComponent as MainContent;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ApplicationFacade.NOTIFY_INIT_APP_COMPLETE,
				ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE,
				ApplicationFacade.NOTIFY_INIT_WHEEL_COMPLETE,
				ApplicationFacade.NOTIFY_LOCATE_AREA,
				ApplicationFacade.NOTIFY_LOCATE_WHEEL,
				ApplicationFacade.NOTIFY_INIT_STATION_CHANGE,
				ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE
			];
		}
		
		private var standArr:ArrayCollection = new ArrayCollection();
		private var wheelArr:ArrayCollection = new ArrayCollection();
		private var wheeltotelarr:ArrayCollection = new ArrayCollection();
		private var n1:NumStatus = new NumStatus();
		private var n2:NumStatus = new NumStatus();
		private var n3:NumStatus = new NumStatus();
		private var n4:NumStatus = new NumStatus();
		private var n5:NumStatus = new NumStatus();
		private var n6:NumStatus = new NumStatus();
		private var n7:NumStatus = new NumStatus();
		private var n8:NumStatus = new NumStatus();
		private var n9:NumStatus = new NumStatus();
		private var n10:NumStatus = new NumStatus();
		private var n11:NumStatus = new NumStatus();
		private var n12:NumStatus = new NumStatus();
		private var n13:NumStatus = new NumStatus();
		private var n14:NumStatus = new NumStatus();
		private var n15:NumStatus = new NumStatus();
		private var n16:NumStatus = new NumStatus();
		private var n17:NumStatus = new NumStatus();
		private var n18:NumStatus = new NumStatus();
		private var n19:NumStatus = new NumStatus();
		private var n20:NumStatus = new NumStatus();
		private var n21:NumStatus = new NumStatus();
		private var n22:NumStatus = new NumStatus();
		private var n23:NumStatus = new NumStatus();
		private var n24:NumStatus = new NumStatus();
		private var n25:NumStatus = new NumStatus();
		private var n26:NumStatus = new NumStatus();
		private var n27:NumStatus = new NumStatus();
		private var n28:NumStatus = new NumStatus();
		private var n29:NumStatus = new NumStatus();
		private var n30:NumStatus = new NumStatus();
		private var n31:NumStatus = new NumStatus();
		private var n32:NumStatus = new NumStatus();
		
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName())
			{
				case ApplicationFacade.NOTIFY_INIT_CONFIG_COMPLETE:
					if(FlexGlobals.topLevelApplication.Station == "中天门")
						mainContent.currentState = "twelve";
					else if(FlexGlobals.topLevelApplication.Station == "后石坞")
						mainContent.currentState = "eight";
					else
						mainContent.currentState = "eleven";
					break;
				
				case ApplicationFacade.NOTIFY_INIT_STATION_CHANGE:
					if(FlexGlobals.topLevelApplication.Station == "中天门")
						mainContent.currentState = "twelve";
					else if(FlexGlobals.topLevelApplication.Station == "后石坞")
						mainContent.currentState = "eight";
					else
						mainContent.currentState = "eleven";
					break;
				
				case ApplicationFacade.NOTIFY_INIT_STAND_COMPLETE:			
					standArr = new ArrayCollection();
					var arr:ArrayCollection = notification.getBody() as ArrayCollection;
					for each(var wm:WheelManageVO in arr)
					{
						if(wm.RopeWay == FlexGlobals.topLevelApplication.Station && wm.Is_Delete == 0)
							standArr.addItem(wm);
					}
					//addPopStand();
					break;
				case ApplicationFacade.NOTIFY_INIT_WHEEL_COMPLETE:			
					wheelArr = notification.getBody() as ArrayCollection;
					changeStatus(wheelArr);
					break;
				case ApplicationFacade.NOTIFY_LOCATE_AREA:			
					var areaid:int = notification.getBody() as int;
					var wheelId:String = notification.getType();
					locatearea(areaid,wheelId);
					break;
				case ApplicationFacade.NOTIFY_LOCATE_WHEEL:			
					var wheelid:String = notification.getBody() as String;
					var ishave:int = 0;
					for each(var wm2:WheelManageVO in standArr)
					{
						if(wm2.WheelId == wheelid)
						{
							ishave++;
							sendNotification(ApplicationFacade.NOTIFY_LOCATE_AREA,wm2.LineAreaId,wm2.WheelId);
						}
					}
					if(ishave == 0)
					{
						Alert.show("索道内无此滚轮！");
					}
					break;
			}
		}
		
		private function changeStatus(arr:ArrayCollection):void
		{
			wheeltotelarr = new ArrayCollection();
			var warntypearr:ArrayCollection = new ArrayCollection;
			warntypearr = FlexGlobals.topLevelApplication.WarnArr;
			var warntip:ArrayCollection = new ArrayCollection();
			
			if(FlexGlobals.topLevelApplication.Station == "中天门")
				var numWheel:Number = 32;
			else if(FlexGlobals.topLevelApplication.Station == "后石坞")
				numWheel = 20;
			else
				numWheel = 26;
			
			for(var i:int=1;i<=numWheel;i++)
			{
				var aw:AreaWheelVO = new AreaWheelVO();
				aw.AreaId = i;
				wheeltotelarr.addItem(aw);
			}
			
			for(var i2:int=0;i2<arr.length;i2++)
			{
				var w:WheelVO = arr[i2];
				for each(var aw2:AreaWheelVO in wheeltotelarr)
				{
					if(aw2.AreaId == w.AreaId)
					{
						if(w.MaintainTime.time>aw2.WheelDate.time)
						{
							aw2.WheelDate = w.MaintainTime;
						}
						aw2.Wheelarr.addItem(w);
					}
				}
			}
			for each(var wm:WheelManageVO in standArr)
			{
				if(wm.Status == "red")
				{
					var obj:Object = new Object();
					obj.areaid = wm.LineAreaId;
					obj.wheelid = wm.WheelId;
					warntip.addItem(obj);
				}
			}
			sendNotification(ApplicationFacade.NOTIFY_WARNING_GET,warntip);
			sendNotification(ApplicationFacade.NOTIFY_WHEELLIST_COMPLETE,standArr);
			
			for each(var wm2:WheelManageVO in standArr)
			{
				for each(var aw3:AreaWheelVO in wheeltotelarr)
				{
					if(wm2.LineAreaId == aw3.AreaId)
					{
						if(wm2.Status == "black")
							aw3.Black++;
						if(wm2.Status == "red")
							aw3.Red++;
						if(wm2.Status == "yellow")
							aw3.Yellow++;
					}
				}
			}
			
			if(FlexGlobals.topLevelApplication.Station == "后石坞")
			{				
				if(mainContent.containsElement(n21))
					mainContent.removeElement(n21);
				if(mainContent.containsElement(n22))
					mainContent.removeElement(n22);
				if(mainContent.containsElement(n23))
					mainContent.removeElement(n23);
				if(mainContent.containsElement(n24))
					mainContent.removeElement(n24);
				if(mainContent.containsElement(n25))
					mainContent.removeElement(n25);
				if(mainContent.containsElement(n26))
					mainContent.removeElement(n26);
				if(mainContent.containsElement(n27))
					mainContent.removeElement(n27);
				if(mainContent.containsElement(n28))
					mainContent.removeElement(n28);	
				if(mainContent.containsElement(n29))
					mainContent.removeElement(n29);	
				if(mainContent.containsElement(n30))
					mainContent.removeElement(n30);	
				if(mainContent.containsElement(n31))
					mainContent.removeElement(n31);	
				if(mainContent.containsElement(n32))
					mainContent.removeElement(n32);	
			}
			else if(FlexGlobals.topLevelApplication.Station == "桃花源")
			{
				if(mainContent.containsElement(n27))
					mainContent.removeElement(n27);
				if(mainContent.containsElement(n28))
					mainContent.removeElement(n28);	
				if(mainContent.containsElement(n29))
					mainContent.removeElement(n29);	
				if(mainContent.containsElement(n30))
					mainContent.removeElement(n30);	
				if(mainContent.containsElement(n31))
					mainContent.removeElement(n31);	
				if(mainContent.containsElement(n32))
					mainContent.removeElement(n32);	
			}
			
			for(var r:int = 0;r<wheeltotelarr.length;r++)
			{   
				var aw4:AreaWheelVO = wheeltotelarr[r];
				
				var source2:String = "assets/image/lun2.png";
				if(aw4.Yellow != 0)
					source2 = "assets/image/ylun2.png";
				if(aw4.Red != 0)
					source2 = "assets/image/rlun2.png";
				
				var source:String = "assets/image/lun.png";
				if(aw4.Yellow != 0)
					source = "assets/image/ylun.png";
				if(aw4.Red != 0)
					source = "assets/image/rlun.png";
				
				switch(aw4.AreaId)
				{
					case 1:
					{
						mainContent.l1.source = source2;
						n1.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n1);
						n1.move(mainContent.l1.x+1,mainContent.l1.y+8);
						break;
					}
					case 2:
					{
						mainContent.l2.source = source2;
						n2.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n2);
						n2.move(mainContent.l2.x+1,mainContent.l2.y+8);
						break;
					}
					case 3:
					{
						mainContent.l3.source = source;
						n3.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n3);
						n3.move(mainContent.l3.x+55,mainContent.l3.y+2);
						break;
					}
					case 4:
					{
						mainContent.l4.source = source;
						n4.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n4);
						n4.move(mainContent.l4.x+55,mainContent.l4.y+2);
						break;
					}
					case 5:
					{
						mainContent.l5.source = source;
						n5.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n5);
						n5.move(mainContent.l5.x+55,mainContent.l5.y+2);
						break;
					}
					case 6:
					{
						mainContent.l6.source = source;
						n6.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n6);
						n6.move(mainContent.l6.x+55,mainContent.l6.y+2);
						break;
					}
					case 7:
					{
						mainContent.l7.source = source;
						n7.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n7);
						n7.move(mainContent.l7.x+55,mainContent.l7.y+2);
						break;
					}
					case 8:
					{
						mainContent.l8.source = source;
						n8.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n8);
						n8.move(mainContent.l8.x+55,mainContent.l8.y+2);
						break;
					}
					case 9:
					{
						mainContent.l9.source = source;
						n9.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n9);
						n9.move(mainContent.l9.x+55,mainContent.l9.y+2);
						break;
					}
					case 10:
					{
						mainContent.l10.source = source;
						n10.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n10);
						n10.move(mainContent.l10.x+55,mainContent.l10.y+2);
						break;
					}
					case 11:
					{
						mainContent.l11.source = source;
						n11.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n11);
						n11.move(mainContent.l11.x+55,mainContent.l11.y+2);
						break;
					}
					case 12:
					{
						mainContent.l12.source = source;
						n12.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n12);
						n12.move(mainContent.l12.x+55,mainContent.l12.y+2);
						break;
					}
					case 13:
					{
						mainContent.l13.source = source;
						n13.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n13);
						n13.move(mainContent.l13.x+55,mainContent.l13.y+2);
						break;
					}
					case 14:
					{
						mainContent.l14.source = source;
						n14.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n14);
						n14.move(mainContent.l14.x+55,mainContent.l14.y+2);
						break;
					}
					case 15:
					{
						mainContent.l15.source = source;
						n15.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n15);
						n15.move(mainContent.l15.x+55,mainContent.l15.y+2);
						break;
					}
					case 16:
					{
						mainContent.l16.source = source;
						n16.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n16);
						n16.move(mainContent.l16.x+55,mainContent.l16.y+2);
						break;
					}
					case 17:
					{
						mainContent.l17.source = source;
						n17.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n17);
						n17.move(mainContent.l17.x+55,mainContent.l17.y+2);
						break;
					}
					case 18:
					{
						mainContent.l18.source = source;
						n18.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n18);
						n18.move(mainContent.l18.x+55,mainContent.l18.y+2);
						break;
					}
					case 19:
					{			
						if(FlexGlobals.topLevelApplication.Station == "后石坞")
						{							
							mainContent.l19.source = source2;
							n19.move(mainContent.l19.x+1,23);
						}
						else
						{
							mainContent.l19.source = source;
							n19.move(1853+55,mainContent.l17.y+2);
						}
						
						n19.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n19);
						break;
					}
					case 20:
					{
						if(FlexGlobals.topLevelApplication.Station == "后石坞")
						{							
							mainContent.l20.source = source2;
							n20.move(mainContent.l20.x+1,248);
						}
						else
						{
							mainContent.l20.source = source;
							n20.move(1853+55,mainContent.l18.y+2);
						}
						
						n20.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n20);
						break;
					}
					case 21:
					{
						mainContent.l21.source = source;
						n21.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n21);
						n21.move(mainContent.l21.x+55,mainContent.l21.y+2);
						break;
					}
					case 22:
					{
						mainContent.l22.source = source;
						n22.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n22);
						n22.move(mainContent.l22.x+55,mainContent.l22.y+2);
						break;
					}
					case 23:
					{
						mainContent.l23.source = source;
						n23.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n23);
						n23.move(mainContent.l23.x+55,mainContent.l23.y+2);
						break;
					}
					case 24:
					{
						mainContent.l24.source = source;
						n24.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n24);
						n24.move(mainContent.l24.x+55,mainContent.l24.y+2);
						break;
					}
					case 25:
					{						
						if(FlexGlobals.topLevelApplication.Station == "桃花源")
						{							
							mainContent.l25.source = source2;
							n25.move(mainContent.l25.x+1,23);
						}
						else
						{
							mainContent.l25.source = source;
							n25.move(2477+55,mainContent.l23.y+2);
						}
						
						n25.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n25);
						break;
					}
					case 26:
					{
						if(FlexGlobals.topLevelApplication.Station == "桃花源")
						{					
							mainContent.l26.source = source2;
							n26.move(mainContent.l26.x+1,248);
						}
						else
						{					
							mainContent.l26.source = source;
							n26.move(2477+55,mainContent.l24.y+2);
						}
						
						n26.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n26);
						break;
					}						
					case 27:
					{
						mainContent.l27.source = source;
						n27.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n27);
						n27.move(mainContent.l27.x+55,mainContent.l27.y+2);
						break;
					}
					case 28:
					{
						mainContent.l28.source = source;
						n28.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n28);
						n28.move(mainContent.l28.x+55,mainContent.l28.y+2);
						break;
					}					
					case 29:
					{
						mainContent.l29.source = source;
						n29.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n29);
						n29.move(mainContent.l29.x+55,mainContent.l29.y+2);
						break;
					}
					case 30:
					{
						mainContent.l30.source = source;
						n30.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n30);
						n30.move(mainContent.l30.x+55,mainContent.l30.y+2);
						break;
					}					
					case 31:
					{
						mainContent.l31.source = source2;
						n31.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n31);
						n31.move(mainContent.l31.x+1,mainContent.l31.y+8);
						break;
					}
					case 32:
					{
						mainContent.l32.source = source2;
						n32.init(aw4.Red,aw4.Yellow,aw4.Black,aw4.AreaId,aw4.WheelDate);
						mainContent.addElement(n32);
						n32.move(mainContent.l32.x+1,mainContent.l32.y+8);
						break;
					}
				}
			}
			
		}
		
		private function onAdd(event:Event):void
		{
			var areaTitleWindow:AreaTitleWindow = facade.retrieveMediator(AreaTitleWindowMediator.NAME).getViewComponent() as AreaTitleWindow;
			PopUpManager.addPopUp(areaTitleWindow, mainContent, true);
			//areaTitleWindow.height = FlexGlobals.topLevelApplication.height-100;
			areaTitleWindow.move(FlexGlobals.topLevelApplication.width/2-areaTitleWindow.width/2,FlexGlobals.topLevelApplication.main.height/2-areaTitleWindow.height/2 + 100);
			var _id:String = event.currentTarget._id;
			var id:int = new int(_id.substr(1));
			var aw:AreaWheelVO = wheeltotelarr[id - 1] as AreaWheelVO;
			aw.StandId = (id-1)/2;
			sendNotification(ApplicationFacade.NOTIFY_ADD_AREA_WINDOWS,aw);
		}
		
		private function locatearea(areaid:int,wheelId:String):void
		{
			var areaTitleWindow:AreaTitleWindow = facade.retrieveMediator(AreaTitleWindowMediator.NAME).getViewComponent() as AreaTitleWindow;
			PopUpManager.addPopUp(areaTitleWindow, mainContent, true);
			//areaTitleWindow.height = FlexGlobals.topLevelApplication.height-100;
			areaTitleWindow.move(FlexGlobals.topLevelApplication.width/2-areaTitleWindow.width/2,FlexGlobals.topLevelApplication.main.height/2-areaTitleWindow.height/2 + 100);
			var aw:AreaWheelVO = wheeltotelarr[areaid-1] as AreaWheelVO;
			aw.StandId = (areaid-1)/2;
			aw.WheelId = wheelId;
			sendNotification(ApplicationFacade.NOTIFY_ADD_AREA_WINDOWS,aw);
		}
		
		private function onStandAdd(event:Event):void
		{
			var titleWindowStand:TitleWindowStand = facade.retrieveMediator(TitleWindowStandMediator.NAME).getViewComponent() as TitleWindowStand;
			PopUpManager.addPopUp(titleWindowStand, mainContent, true);
			titleWindowStand.move(FlexGlobals.topLevelApplication.width/2-titleWindowStand.width/2,FlexGlobals.topLevelApplication.main.height/2-titleWindowStand.height/2 +100);
			//titleWindowStand.height = FlexGlobals.topLevelApplication.height-100;
			var _id:String = event.currentTarget._standid;
			var id:int = new int(_id.substr(1));
			sendNotification(ApplicationFacade.NOTIFY_ADD_STAND_WINDOWS,id);
		}
	}
}