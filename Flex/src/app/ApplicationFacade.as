package app
{
	import spark.components.Application;
	
	import app.controller.NotifyInchRealtimeAddCommand;
	import app.controller.NotifyInitAppCommand;
	import app.controller.NotifyInitAppCompleteCommand;
	import app.controller.NotifyMainOverviewAddCommand;
	import app.controller.NotifyMenuInchAnalysisCommand;
	import app.controller.NotifyMenuInchManagerCommand;
	import app.controller.NotifyMenuInchRealtimeCommand;
	import app.controller.NotifyMenuMainForceCommand;
	import app.controller.NotifyMenuMainInchCommand;
	import app.controller.NotifyMenuMainOverviewCommand;
	import app.controller.NotifyRopewayChangeCommand;
	import app.controller.NotifySocketEngineTempCommand;
	import app.controller.NotifySocketInchCommand;
	import app.controller.NotifySocketSurroundingTempCommand;
	import app.controller.StartupCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.facade.Facade;
	
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
		 * 提示信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>String</td><td>在 Alert 控件中显示的文本字符串。</td>
		 * 	</tr>
		 * 	<tr>
		 *    <td>Function</td><td>按下 Alert 控件上的任意按钮时将调用的事件处理函数。传递给此处理函数的事件对象是 CloseEvent 的一个实例；此对象的 detail 属性包含 Alert.OK、Alert.CANCEL、Alert.YES 或 Alert.NO 值。</td>
		 * 	</tr>
		 * 	<tr>
		 *    <td>uint</td><td>控件中放置的按钮。有效值为 Alert.OK、Alert.CANCEL、Alert.YES 和 Alert.NO。</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ALERT_INFO:String				= "AlertInfo";
				
		/**
		 * 提示警告
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>String</td><td>在 Alert 控件中显示的文本字符串。</td>
		 * 	</tr>
		 * 	<tr>
		 *    <td>Function</td><td>按下 Alert 控件上的任意按钮时将调用的事件处理函数。传递给此处理函数的事件对象是 CloseEvent 的一个实例；此对象的 detail 属性包含 Alert.OK、Alert.CANCEL、Alert.YES 或 Alert.NO 值。</td>
		 * 	</tr>
		 * 	<tr>
		 *    <td>uint</td><td>控件中放置的按钮。有效值为 Alert.OK、Alert.CANCEL、Alert.YES 和 Alert.NO。</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ALERT_ALARM:String				= "AlertAlarm";
		
		/**
		 * 提示错误
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>String</td><td>在 Alert 控件中显示的文本字符串。</td>
		 * 	</tr>
		 * 	<tr>
		 *    <td>Function</td><td>按下 Alert 控件上的任意按钮时将调用的事件处理函数。传递给此处理函数的事件对象是 CloseEvent 的一个实例；此对象的 detail 属性包含 Alert.OK、Alert.CANCEL、Alert.YES 或 Alert.NO 值。</td>
		 * 	</tr>
		 * 	<tr>
		 *    <td>uint</td><td>控件中放置的按钮。有效值为 Alert.OK、Alert.CANCEL、Alert.YES 和 Alert.NO。</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ALERT_ERROR:String				= "AlertError";
		
		/**
		 * 配置信息初始化完成
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>ConfigVO</td><td>配置信息</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_INIT_CONFIG_COMPLETE:String 		= "InitConfigComplete";
		
		/**
		 * 索道信息初始化完成
		 **/
		//public static const NOTIFY_INIT_ROPEWAY_COMPLETE:String 	= "InitRopewayComplete";
		
		
		public static const NOTIFY_INIT_APP:String 					= "InitApp";
		
		/**
		 * 程序初始化完成
		 **/
		public static const NOTIFY_INIT_APP_COMPLETE:String 		= "InitAppComplete";
				
		/**
		 * 抱索力实时信息
		 **/
		public static const NOTIFY_SOCKET_FORCE:String 				= "SocketForce";
		
		/**
		 * 动力室温度
		 **/
		public static const NOTIFY_SOCKET_ENGINE_TEMP:String 		= "SocketEngineTemp";
		
		/**
		 * 张紧小尺
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>RopewayDict</td><td>索道</td>
		 * 	</tr>
		 * 	<tr>
		 *    <td>InchVO</td><td>张紧小尺数值</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_SOCKET_INCH:String 				= "SocketInch";
		
		public static const NOTIFY_SOCKET_SURROUDING_TEMP:String 	= "SocketSurroudingTemp";
				
		/**
		 * 报警实时信息
		 **/
		public static const NOTIFY_ROPEWAY_ALARM_REALTIME:String 	= "RopewayAlarmRealtime";
		
		/**
		 * 站点改变
		 **/
		public static const NOTIFY_MAIN_STATION_CHANGE:String 		= "MainGroupChange";
		
		public static const NOTIFY_ROPEWAY_CHANGE:String 			= "MainRopewayChange";
		
		/**
		 * 分析表改变
		 **/
		public static const NOTIFY_MAIN_ANALYSIS_CHANGE:String 		= "MainGroupAnalysisChange";
		
		/**
		 * 设置改变
		 **/
		//public static const NOTIFY_MAIN_MANAGER_CHANGE:String 		= "MainGroupMangerChange";
		
		
		public static const ACTION_UPDATE_INCH:String 					= "ActionUpdateInch";		
		public static const ACTION_UPDATE_INCH_HISTORY:String 			= "ActionUpdateInchHistory";	
		
		public static const ACTION_UPDATE_SURROUDING_TEMP_FST:String 	= "ActionUpdateSurroudingTempFst";		
		public static const ACTION_UPDATE_SURROUDING_TEMP_SND:String 	= "ActionUpdateSurroudingTempSnd";	
		
		public static const ACTION_UPDATE_ENGINE_TEMP_FST:String 	= "ActionUpdateEngineTempFst";		
		public static const ACTION_UPDATE_ENGINE_TEMP_SND:String 	= "ActionUpdateEngineTempSnd";
		
		public static const ACTION_MAIN_PANEL_CHANGE:String 			= "ActionMainPanelChange";
		public static const ACTION_INCH_PANEL_CHANGE:String 			= "ActionInchPanelChange";
		
		/**
		 * 主菜单-监测概览
		 **/
		public static const NOTIFY_MENU_MAIN_OVERVIEW:String 		= "MenuMainOverview";
		
		public static const NOTIFY_MAIN_OVERVIEW_ADD:String 		= "MainOverviewAdd";
		
		/**
		 * 主菜单-抱索力
		 **/
		public static const NOTIFY_MENU_MAIN_FORCE:String 			= "MenuMainForce";
		
		/**
		 * 主菜单-动力室电机温度
		 **/
		public static const NOTIFY_MENU_MAIN_ENGINE_TEMP:String 	= "MenuMainEngineTemp";
		
		/**
		 * 主菜单-张紧小尺
		 **/
		public static const NOTIFY_MENU_MAIN_INCH:String 			= "MenuMainInch";
		
		public static const NOTIFY_MENU_INCH_REALTIME:String 		= "MenuInchRealtime";
		
		public static const NOTIFY_INCH_REALTIME_ADD:String 		= "MainInchRealtimeAdd";
		
		public static const NOTIFY_MENU_INCH_ANALYSIS:String 		= "MenuInchAnalysis";
		
		public static const NOTIFY_MENU_INCH_MANAGER:String 		= "MenuInchManager";
		
		
		/**
		 * 主菜单-风速风向
		 **/
		public static const NOTIFY_MENU_MAIN_WIND:String 			= "MenuMainWind";
		
		/**
		 * 菜单-实时检测
		 **/
		public static const NOTIFY_MENU_REALTIME_DETECTION:String 	= "MenuRealtimeDetection";
		
		/**
		 * 菜单-实时检测
		 **/
		public static const NOTIFY_MENU_ENGINE_TEMP_REALTIME_DETECTION:String 	= "MenuEngineTempRealtimeDetection";
		
		/**
		 * 菜单-今日概览
		 **/
		public static const NOTIFY_MENU_TODAY_OVERVIEW:String 		= "MenuTodayOverview";
		
		/**
		 * 菜单-分析统计
		 **/
		public static const NOTIFY_MENU_ANALYSIS:String 		= "MenuAnalysis";
		
		/**
		 * 菜单-车厢设置
		 **/
		public static const NOTIFY_MENU_MANAGE:String 			= "MenuManage";
		
		/**
		 * 报警处置
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>RopewayAlarmVO</td><td>报警信息</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ROPEWAY_ALARM_DEAL:String 	= "RopewayAlarmDeal";
		
		/**
		 * 吊箱设置
		 **/
		public static const NOTIFY_ROPEWAY_INFO_SET:String 		= "RopewayInfoSet";
		
		/**
		 * Socket同步
		 **/
		public static const NOTIFY_SOCKET_KEEP:String 			= "SocketKeep";
		
		/**
		 * 新建抱索器
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>String</td><td>所属索道</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ROPEWAY_BASEINFO_NEW:String 	= "RopewayBaseInfoNew";
		
		/**
		 * 编辑抱索器
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>RopewayBaseInfoVO</td><td>抱索器基本信息</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ROPEWAY_BASEINFO_EDIT:String 	= "RopewayBaseInfoEdit";
			
		
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
			
			registerCommand( NOTIFY_INIT_APP, NotifyInitAppCommand);
			
			registerCommand( NOTIFY_INIT_APP_COMPLETE, NotifyInitAppCompleteCommand);
			
			registerCommand( NOTIFY_SOCKET_INCH , NotifySocketInchCommand);
			
			registerCommand( NOTIFY_SOCKET_ENGINE_TEMP , NotifySocketEngineTempCommand);
							 
			registerCommand( NOTIFY_SOCKET_SURROUDING_TEMP , NotifySocketSurroundingTempCommand);
			
			registerCommand( NOTIFY_ROPEWAY_CHANGE , NotifyRopewayChangeCommand);
						
			registerCommand( NOTIFY_MENU_MAIN_OVERVIEW , NotifyMenuMainOverviewCommand);
			
			registerCommand( NOTIFY_MAIN_OVERVIEW_ADD , NotifyMainOverviewAddCommand);
			
			registerCommand( NOTIFY_MENU_MAIN_INCH , NotifyMenuMainInchCommand);	
			
			registerCommand( NOTIFY_MENU_INCH_REALTIME , NotifyMenuInchRealtimeCommand);		
			
			registerCommand( NOTIFY_INCH_REALTIME_ADD , NotifyInchRealtimeAddCommand);	
			
			registerCommand( NOTIFY_MENU_INCH_ANALYSIS , NotifyMenuInchAnalysisCommand);	
			
			registerCommand( NOTIFY_MENU_INCH_MANAGER , NotifyMenuInchManagerCommand);		
			
			registerCommand( NOTIFY_MENU_MAIN_FORCE , NotifyMenuMainForceCommand);
		}
	}
}