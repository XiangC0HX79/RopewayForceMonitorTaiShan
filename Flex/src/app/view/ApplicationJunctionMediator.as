package app.view
{
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;
	
	public class ApplicationJunctionMediator extends JunctionMediator
	{
		public static const NAME:String = "ApplicationJunctionMediator";
		
		public function ApplicationJunctionMediator()
		{
			super(NAME, new Junction);
		}
		
		override public function onRegister():void
		{
			junction.registerPipe( PipeAwareModule.APP_TO_MODULE_PIPE, Junction.OUTPUT, new TeeSplit );
			junction.registerPipe( PipeAwareModule.MODULE_TO_APP_PIPE, Junction.INPUT, new TeeMerge );
			junction.addPipeListener( PipeAwareModule.MODULE_TO_APP_PIPE, this, handlePipeMessage );
		}
	}
}