package app.view
{
	import app.model.AppParamProxy;
	import app.view.components.ImageGroup;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ImageGroupMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ImageGroupMediator";
		
		public function ImageGroupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			var appParamProxy:AppParamProxy = facade.retrieveProxy(AppParamProxy.NAME) as AppParamProxy;
			imageGroup.appParam = appParamProxy.appParam;
		}
		
		protected function get imageGroup():ImageGroup
		{
			return viewComponent as ImageGroup;
		}
	}
}