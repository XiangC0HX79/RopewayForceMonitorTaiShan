/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package forceMonitor.view
{
	import mx.core.UIComponent;
		
	import forceMonitor.ForceMonitorFacade;
	import forceMonitor.common.PipeAwareModule;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Filter;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.PipeListener;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	
	public class ForceJunctionMediator extends JunctionMediator
	{
		public static const NAME:String = 'ForceJunctionMediator';

		public function ForceJunctionMediator( )
		{
			super( NAME, new Junction() );			
		}
		
		override public function onRegister():void
		{			
			junction.addPipeListener( PipeAwareModule.INFO_TO_FORCE, this, handlePipeMessage );
		}
				
		/**
		 * List Notification Interests.
		 * <P>
		 * Adds subclass interests to those of the JunctionMediator.</P>
		 */
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();
			interests.push(ForceMonitorFacade.NOTIFY_PIPE_SEND_FORCE);
			return interests;
		}

		override public function handleNotification( note:INotification ):void
		{			
			switch( note.getName() )
			{
				case ForceMonitorFacade.NOTIFY_PIPE_SEND_FORCE:
					if(junction.hasOutputPipe(PipeAwareModule.FORCE_TO_INFO))
					{
						var buttonExported:Boolean = junction.sendMessage( PipeAwareModule.FORCE_TO_INFO, new Message(Message.NORMAL,null,note.getBody()));
					}
					break;
				
				default:
					super.handleNotification(note);
			}
		}
		
		override public function handlePipeMessage( message:IPipeMessage ):void
		{			
			junction.removePipe(PipeAwareModule.FORCE_TO_INFO);
			junction.removePipe(PipeAwareModule.INFO_TO_FORCE);
			
			sendNotification(ForceMonitorFacade.NOTIFY_UNLOAD_APPE);
		}
	}
}