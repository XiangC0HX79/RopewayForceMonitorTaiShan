package app.model
{
	import app.view.components.TitleWindowBaseInfo;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	import mx.utils.*;
	
	import org.puremvc.as3.interfaces.IProxy;

	public class MaintainTypeProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "MaintainTypeProxy";
		
		public static var typeList:ArrayCollection = new ArrayCollection();
		
		public function MaintainTypeProxy(data:Object=null)
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get wheelDict():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function InitMaintainType():void
		{
			send("GetDicListForMaintenance",onInitMaintainType,"");
		}
		
		private function onInitMaintainType(event:ResultEvent):void
		{
			var arr:ArrayCollection = new ArrayCollection();
			typeList = new ArrayCollection();
			for each(var obj:* in event.result)
			{
				arr.addItem(obj);
				typeList.addItem(obj.DicValue);
			}
			WheelHistoryProxy.MaintainType = arr;
		}
	}
}