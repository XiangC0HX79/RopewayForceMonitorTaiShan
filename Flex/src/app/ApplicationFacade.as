package app
{
	import app.controller.StartupCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import spark.components.Application;
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		public static const STARTUP:String 							= "startup";
		
		/**
		 * 显示等待
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>String</td><td>显示内容</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_MAIN_LOADING_SHOW:String 		= "MainLoadingShow";
		
		/**
		 * 隐藏等待
		 **/
		public static const NOTIFY_MAIN_LOADING_HIDE:String 		= "MainLoadingHide";
		
		
		/**
		 * 索道信息初始化完成
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>RopewayVO</td><td>最后一个抱索器信息</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_INIT_ROPEWAY_COMPLETE:String 	= "InitRopewayComplete";
				
		/**
		 * 程序初始化完成
		 **/
		public static const NOTIFY_INIT_APP_COMPLETE:String 		= "InitAppComplete";
		
		
		/**
		 * 抱索器实时信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>RopewayVO</td><td>抱索器信息</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ROPEWAY_INFO_REALTIME:String 	= "RopewayInfoRealtime";
		
		
		/**
		 * 菜单-实时检测
		 **/
		public static const NOTIFY_MENU_REALTIME_DETECTION:String 	= "MenuRealtimeDetection";
		
		/**
		 * 菜单-今日概览
		 **/
		public static const NOTIFY_MENU_TODAY_OVERVIEW:String 		= "MenuTodayOverview";
		
		/**
		 * Singleton ApplicationFacade Factory Method
		 */
		public static function getInstance() : ApplicationFacade 
		{
			if ( instance == null ) instance = new ApplicationFacade( );
			return instance as ApplicationFacade;
		}
		
		/**
		* Start the application
		*/
		public function startup(app:Object):void 
		{
			sendNotification( STARTUP, app );	
		}
		
		/**
		 * Register Commands with the Controller 
		 */
		override protected function initializeController( ) : void
		{
			super.initializeController();
			
			registerCommand( STARTUP, StartupCommand );	
		}
	}
}