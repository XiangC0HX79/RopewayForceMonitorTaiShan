package app.model
{
	import com.adobe.serialization.json.JSON;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import app.model.vo.InchVO;
	import app.model.vo.InchValueVO;
	import app.model.vo.InternalVO;
	import app.model.vo.PressVO;
	import app.model.vo.PressValueVO;
	
	import org.puremvc.as3.multicore.utilities.loadup.interfaces.ILoadupProxy;
	
	use namespace InternalVO;
	
	public class InchProxy extends  WebServiceProxy implements ILoadupProxy
	{
		public static const NAME:String = "InchProxy";
		public static const SRNAME:String = "InchProxySR";
		
		public static const LOADED:String = "InchProxy/Loaded";
		public static const FAILED:String = "InchProxy/Failed";
		
		public function InchProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function load():void
		{			
			var token:AsyncToken = sendNoBusy("T_JC_ZJXC_Load");
			token.addResponder(new AsyncResponder(onLoad,onFault));
		}		
		
		private function onFault(event:FaultEvent,t:Object = null):void
		{
			sendNotification(FAILED,NAME);			
		}
		
		private function onLoad(event:ResultEvent,t:Object = null):void
		{
			var jd:* = JSON.decode(String(event.result));
			
			for each(var item:* in jd.MonthAve)
			{
				InchVO.getNamed(item.FromRopeWay).aveMon = item.AveValue.toFixed(3);
			}
			
			for each(item in jd.ThrMonthAve)
			{
				InchVO.getNamed(item.FromRopeWay).aveThreeMon = item.AveValue.toFixed(3);
			}
			
			for each(item in jd.LastDayAve)
			{
				InchVO.getNamed(item.FromRopeWay).periodAveDay = item.AveValue.toFixed(3);
			}
			
			for each(item in jd.LastMonthAve)
			{
				InchVO.getNamed(item.FromRopeWay).periodAveMon = item.AveValue.toFixed(3);
			}
			
			for each(item in jd.LastThrMonthAve)
			{
				InchVO.getNamed(item.FromRopeWay).periodThreeMon = item.AveValue.toFixed(3);
			}
			
			for each(item in jd.History)
			{
				var inchValue:InchValueVO = new InchValueVO;
				inchValue.date = new Date(Date.parse(item.DeteDate));
				inchValue.value = item.DeteValue;
				
				InchVO.getNamed(item.FromRopeWay).PushItem(inchValue,false);
			}
						
			for each(item in jd.Press)
			{
				var pressValue:PressValueVO = new PressValueVO;
				pressValue.date = new Date(Date.parse(item.DeteDate));
				pressValue.value = item.DeteValue;
			
				PressVO.getNamed(item.FromRopeWay).PushItem(pressValue,false);
			}
						
			sendNotification(LOADED,NAME);
		}
		
		public function AddInch(rwName:String,date:Date,value:Number):void
		{			
			var inchValue:InchValueVO = new InchValueVO;
			inchValue.date = date;
			inchValue.value = Number(value.toFixed(2));
			
			InchVO.getNamed(rwName).PushItem(inchValue);
		}
				
		public function AddPress(rwName:String,date:Date,value:Number):void
		{			
			var pressValue:PressValueVO = new PressValueVO;
			pressValue.date = date;
			pressValue.value = Number(value.toFixed(2));
			
			PressVO.getNamed(rwName).PushItem(pressValue);
		}
	}
}