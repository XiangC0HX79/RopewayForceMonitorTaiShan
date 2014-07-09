package app.controller
{	
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
	
	public class NotifyWindValueChartCommand extends SimpleCommand
	{		
		override public function execute(notification:INotification):void
		{
			var notify:NotifyWindAnalysisValueVO = NotifyWindAnalysisValueVO(notification.getBody());
			
			var windPx:WindProxy =  facade.retrieveProxy(WindProxy.NAME) as WindProxy;
			
			var token:AsyncToken = windPx.WindValueGetModelList(notify.bracket,notify.sTime,notify.eTime);	
			token.addResponder(new AsyncResponder(WindValueGetModelListResult,function onFault(error:FaultEvent, token:Object = null):void{}));
			token.resultHandle = notify.ResultHandle;
		}
		
		private function WindValueGetModelListResult(result:ResultEvent, token:Object = null):void
		{
			var colChart:ArrayCollection = new ArrayCollection;
			
			for each(var item:* in result.result)
			{
				colChart.addItem(WindValueAnalysisVO.facatoryCreate(item));
			}
			
			result.token.resultHandle(colChart);
		}
	}
}