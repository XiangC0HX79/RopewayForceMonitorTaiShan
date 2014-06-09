package app.model
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.ResultEvent;
	
	import app.ApplicationFacade;
	import app.model.vo.HolderMgVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	
	public class HolderMgProxy extends WebServiceProxy implements IProxy
	{
		public static const NAME:String = "HolderMgProxy";
		
		public function HolderMgProxy()
		{
			super(NAME, new ArrayCollection);
		}
		
		public function get list():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		public function InitHolderMg(ropeway:String,area:String):void
		{
			var where:String = "RopeWay = '" + ropeway + "' AND LineAreaId = '" + area + "'";
			send("T_MT_HolderMgBLL_GetAllNews",onInitHolderMgDict,where);
		}
		
		private function onInitHolderMgDict(event:ResultEvent):void
		{
			list.removeAll();
			
			for each(var item:* in event.result)
			{
				list.addItem(new HolderMgVO(item));
			}
		}
		
		public function Add(item:HolderMgVO):AsyncToken
		{
			var token:AsyncToken = send("T_MT_HolderMg_Add",onAdd,JSON.stringify(item.valueOf));	
			token.holderMgVO = item;
			return token;
		}
		
		private function onAdd(event:ResultEvent):void
		{
			var holderMgVO:HolderMgVO = event.token.holderMgVO;
			holderMgVO.Id = int(event.result);
			list.addItem(holderMgVO);
		}
		
		public function Edit(item:HolderMgVO):AsyncToken
		{
			var token:AsyncToken = send("T_MT_HolderMg_Update",onEdit,JSON.stringify(item.valueOf));	
			token.holderMgVO = item;
			return token;
		}
		
		private function onEdit(event:ResultEvent):void
		{
			if(event.result)
			{
				var holderMgVO:HolderMgVO = event.token.holderMgVO;
				for each(var item:HolderMgVO in list)
				{
					if(item.Id == holderMgVO.Id)
					{
						item.copy(holderMgVO);
						break;
					}
				}
			}
			else
			{
				
			}
		}
		
		public function Del(item:HolderMgVO):AsyncToken
		{
			var token:AsyncToken = send("T_MT_HolderMg_Delete",onDel,item.Id);	
			token.holderMgVO = item;
			return token;
		}
		
		private function onDel(event:ResultEvent):void
		{
			if(event.result)
			{
				list.removeItemAt(list.getItemIndex(event.token.holderMgVO));
				Alert.show("成功删除维护计划！");
			}
			else
			{
				Alert.show("删除维护计划失败！");				
			}
		}
	}
}