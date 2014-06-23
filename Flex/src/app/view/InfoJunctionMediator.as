/*
 PureMVC AS3 MultiCore Demo – Flex PipeWorks 
 Copyright (c) 2008 Cliff Hall <cliff.hall@puremvc.org>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
 */
package app.view
{
	import app.ApplicationFacade;
	import app.common.PipeAwareModule;
	import app.model.vo.ForceVO;
	import app.model.vo.RopewayStationVO;
	
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeAware;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeFitting;
	import org.puremvc.as3.multicore.utilities.pipes.interfaces.IPipeMessage;
	import org.puremvc.as3.multicore.utilities.pipes.messages.Message;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Junction;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.JunctionMediator;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.Pipe;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeMerge;
	import org.puremvc.as3.multicore.utilities.pipes.plumbing.TeeSplit;
	
	public class InfoJunctionMediator extends JunctionMediator
	{
		public static const NAME:String = 'InfoJunctionMediator';
		
		public function InfoJunctionMediator( )
		{
			super( NAME, new Junction() );
		}

		override public function onRegister():void
		{
			junction.registerPipe( PipeAwareModule.INFO_TO_FORCE,  Junction.OUTPUT, new TeeSplit() );
			
			junction.registerPipe( PipeAwareModule.FORCE_TO_INFO,  Junction.INPUT, new TeeMerge() );
			
			junction.addPipeListener( PipeAwareModule.FORCE_TO_INFO, this, handlePipeMessage );
		}
		
		/**
		 * ShellJunction related Notification list.
		 * <P>
		 * Adds subclass interests to JunctionMediator interests.</P>
		 */
		override public function listNotificationInterests():Array
		{
			var interests:Array = super.listNotificationInterests();	
			interests.push(ApplicationFacade.NOTIFY_SOCKET_FORCE_INIT);	
			interests.push(ApplicationFacade.NOTIFY_MAIN_FORCE_INIT);		
			return interests;
		}

		/**
		 * Handle ShellJunction related Notifications.
		 */
		override public function handleNotification( note:INotification ):void
		{
			
			switch( note.getName() )
			{
				case ApplicationFacade.NOTIFY_SOCKET_FORCE_INIT:
					var moduleForce:IPipeAware = note.getBody() as IPipeAware;
					moduleForce.acceptInputPipe(PipeAwareModule.INFO_TO_FORCE,junction.retrievePipe(PipeAwareModule.INFO_TO_FORCE));
					moduleForce.acceptOutputPipe(PipeAwareModule.FORCE_TO_INFO,junction.retrievePipe(PipeAwareModule.FORCE_TO_INFO));
					break;
				
				case ApplicationFacade.NOTIFY_MAIN_FORCE_INIT:
					junction.sendMessage(PipeAwareModule.INFO_TO_FORCE,new Message(Message.NORMAL,null,"unload"));
					
					moduleForce = note.getBody() as IPipeAware;
					moduleForce.acceptInputPipe(PipeAwareModule.INFO_TO_FORCE,junction.retrievePipe(PipeAwareModule.INFO_TO_FORCE));
					moduleForce.acceptOutputPipe(PipeAwareModule.FORCE_TO_INFO,junction.retrievePipe(PipeAwareModule.FORCE_TO_INFO));
					
					sendNotification(ApplicationFacade.NOTIFY_SOCKET_FORCE_UPLOAD);
					break;
				
				// Let super handle the rest (ACCEPT_OUTPUT_PIPE, ACCEPT_INPUT_PIPE, SEND_TO_LOG)								
				default:
					super.handleNotification(note);					
			}
		}
		
		override public function handlePipeMessage( message:IPipeMessage ):void
		{
			var force:ForceVO =  new ForceVO(message.getBody());
			
			sendNotification(ApplicationFacade.NOTIFY_PIPE_SEND_FORCE,force)	
		}
	}
}