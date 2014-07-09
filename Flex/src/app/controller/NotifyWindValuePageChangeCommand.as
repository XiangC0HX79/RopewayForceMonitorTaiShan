package app.controller
{
	import com.adobe.serialization.json.JSON;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AsyncResponder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import app.model.WindProxy;
	import app.model.notify.NotifyWindAnalysisValueVO;
	import app.model.vo.WindValueAnalysisVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
	
	public class NotifyWindValuePageChangeCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var notify:NotifyWindAnalysisValueVO = NotifyWindAnalysisValueVO(notification.getBody());
			
			var windPx:WindProxy =  facade.retrieveProxy(WindProxy.NAME) as WindProxy;
			
			var token:AsyncToken = windPx.WindValueGetPageData(notify.bracket,notify.sTime,notify.eTime,notify.pageIndex,notify.pageSize);			
			token.addResponder(new AsyncResponder(WindValueGetPageDataResult,function onFault(error:FaultEvent, token:Object = null):void{}));
			token.resultHandle = notify.ResultHandle;
		}
		
		private function WindValueGetPageDataResult(result:ResultEvent, token:Object = null):void
		{
			var jd:* = JSON.decode(String(result.result));
			
			var totalCount:int = jd.totalCount;
			
			var colGrid:ArrayCollection = new ArrayCollection;
			
			for each(var item:* in jd.list)
			{
				colGrid.addItem(WindValueAnalysisVO.facatoryCreate(item));
			}
			
			result.token.resultHandle(totalCount,colGrid);
		}
	}
}