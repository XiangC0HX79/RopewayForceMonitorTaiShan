package app
{
	import spark.components.Application;
	
	import app.controller.NotifyInitAppCommand;
	import app.controller.NotifyInitAppCompleteCommand;
	import app.controller.NotifyMenuEngineAnalysisCommand;
	import app.controller.NotifyMenuEngineManagerCommand;
	import app.controller.NotifyMenuEngineRealtimeCommand;
	import app.controller.NotifyMenuInchAnalysisCommand;
	import app.controller.NotifyMenuInchManagerCommand;
	import app.controller.NotifyMenuInchRealtimeCommand;
	import app.controller.NotifyMenuMainEngineCommand;
	import app.controller.NotifyMenuMainForceCommand;
	import app.controller.NotifyMenuMainInchCommand;
	import app.controller.NotifyMenuMainOverviewCommand;
	import app.controller.NotifyPipeSendForceCommand;
	import app.controller.NotifyRopewayChangeCommand;
	import app.controller.NotifySocketEngineTempCommand;
	import app.controller.NotifySocketForceUploadCommand;
	import app.controller.NotifySocketInchCommand;
	import app.controller.NotifySocketSurroundingTempCommand;
	import app.controller.NotifySocketWindCommand;
	import app.controller.StartupCommand;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.interfaces.INotification;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	import org.puremvc.as3.multicore.utilities.flex.config.model.ConfigProxy;
	import org.puremvc.as3.multicore.utilities.loadup.controller.LoadupResourceFailedCommand;
	import org.puremvc.as3.multicore.utilities.loadup.controller.LoadupResourceLoadedCommand;
	import org.puremvc.as3.multicore.utilities.loadup.model.LoadupMonitorProxy;
	
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
		//public static const NOTIFY_INIT_APP_COMPLETE:String 		= "InitAppComplete";
				
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
		
		public static const NOTIFY_SOCKET_WIND:String 				= "SocketWind";
		
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
		
		public static const ACTION_UPDATE_SURROUDING_TEMP_FST:String 	= "ActionUpdateSurroudingTempFst";		
		public static const ACTION_UPDATE_SURROUDING_TEMP_SND:String 	= "ActionUpdateSurroudingTempSnd";	
		
		public static const ACTION_UPDATE_ENGINE_FST:String 			= "ActionUpdateEngineFst";		
		public static const ACTION_UPDATE_ENGINE_SND:String 			= "ActionUpdateEngineSnd";
		
		public static const ACTION_UPDATE_FORCE_FST:String 				= "ActionUpdateForceFst";		
		public static const ACTION_UPDATE_FORCE_SND:String 				= "ActionUpdateForceSnd";
		
		public static const ACTION_UPDATE_WIND:String 					= "ActionUpdateWind";	
		public static const ACTION_REFRESH_WIND:String 					= "ActionRefreshWind";	
		
		public static const ACTION_MAIN_PANEL_CHANGE:String 			= "ActionMainPanelChange";
		public static const ACTION_INCH_PANEL_CHANGE:String 			= "ActionInchPanelChange";
		public static const ACTION_ENGINE_PANEL_CHANGE:String 			= "ActionEnginePanelChange";
		
		/**
		 * 主菜单-监测概览
		 **/
		public static const NOTIFY_MENU_MAIN_OVERVIEW:String 		= "MenuMainOverview";
		
		/**
		 * 主菜单-抱索力
		 **/		
		public static const NOTIFY_CONFIG_LOADED:String 			= "SocketConfigLoaded";
		
		public static const NOTIFY_CONFIG_FAILED:String 			= "SocketConfigFailed";
		
		public static const NOTIFY_SOCKET_FORCE_LOADED:String 		= "SocketForceLoaded";
		
		public static const NOTIFY_SOCKET_FORCE_FAILED:String 		= "SocketForceFailed";
		
		public static const NOTIFY_SOCKET_LOADED:String 			= "SocketLoaded";
		
		public static const NOTIFY_SOCKET_FAILED:String 			= "SocketFailed";
		
		public static const NOTIFY_SURROUNDING_LOADED:String 		= "SurroundingLoaded";
		
		public static const NOTIFY_SURROUNDING_FAILED:String 		= "SurroundingFailed";
		
		public static const NOTIFY_ENGINE_LOADED:String 			= "EngineLoaded";
		
		public static const NOTIFY_ENGINE_FAILED:String 			= "EngineFailed";
		
		public static const NOTIFY_INCH_LOADED:String 				= "InchLoaded";
		
		public static const NOTIFY_INCH_FAILED:String 				= "InchFailed";
		
		public static const NOTIFY_WIND_LOADED:String 				= "WindLoaded";
		
		public static const NOTIFY_WIND_FAILED:String 				= "WindFailed";
		
		
		
		public static const NOTIFY_SOCKET_FORCE_INIT:String 		= "SocketForceInit";
		
		public static const NOTIFY_SOCKET_FORCE_UPLOAD:String 		= "SocketForceUpload";
		
		public static const NOTIFY_MENU_MAIN_FORCE:String 			= "MenuMainForce";
		
		public static const NOTIFY_MAIN_FORCE_INIT:String 			= "MainForceInit";
		
		public static const NOTIFY_PIPE_SEND_FORCE:String			="PipeSendForce";
		
		/**
		 * 主菜单-动力室电机温度
		 **/
		public static const NOTIFY_MENU_MAIN_ENGINE_TEMP:String 	= "MenuMainEngineTemp";
		
		/**
		 * 主菜单-张紧小尺
		 **/
		public static const NOTIFY_MENU_MAIN_INCH:String 			= "MenuMainInch";
		
		public static const NOTIFY_MENU_INCH_REALTIME:String 		= "MenuInchRealtime";
				
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
		public static const NOTIFY_MENU_ENGINE_REALTIME:String 		= "MenuEngineRealtime";
		public static const NOTIFY_MENU_ENGINE_ANALYSIS:String 		= "MenuEngineAnalysis";
		public static const NOTIFY_MENU_ENGINE_MANAGER:String 		= "MenuEngineManager";
		
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
			
		
		public function ApplicationFacade(key:String)
		{
			super(key);
		}
		
		/**
		 * Singleton ApplicationFacade Factory Method
		 */
		public static function getInstance(key:String) : ApplicationFacade 
		{
			if ( instanceMap[ key ] == null ) instanceMap[ key ] = new ApplicationFacade( key);
			return instanceMap[ key ] as ApplicationFacade;
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
			
			registerCommand( NOTIFY_CONFIG_LOADED, LoadupResourceLoadedCommand);
			registerCommand( NOTIFY_SOCKET_FORCE_LOADED , LoadupResourceLoadedCommand);
			registerCommand( NOTIFY_SOCKET_LOADED , LoadupResourceLoadedCommand);
			registerCommand( NOTIFY_SURROUNDING_LOADED , LoadupResourceLoadedCommand);
			registerCommand( NOTIFY_ENGINE_LOADED , LoadupResourceLoadedCommand);
			registerCommand( NOTIFY_INCH_LOADED , LoadupResourceLoadedCommand);
			registerCommand( NOTIFY_WIND_LOADED , LoadupResourceLoadedCommand);
			
			registerCommand( NOTIFY_CONFIG_FAILED, LoadupResourceFailedCommand);
			registerCommand( NOTIFY_SOCKET_FORCE_FAILED, LoadupResourceFailedCommand);
			registerCommand( NOTIFY_SOCKET_FAILED, LoadupResourceFailedCommand);
			registerCommand( NOTIFY_SURROUNDING_FAILED , LoadupResourceLoadedCommand);
			registerCommand( NOTIFY_ENGINE_FAILED , LoadupResourceLoadedCommand);
			registerCommand( NOTIFY_INCH_FAILED , LoadupResourceLoadedCommand);
			registerCommand( NOTIFY_WIND_FAILED , LoadupResourceLoadedCommand);
			
			registerCommand( LoadupMonitorProxy.LOADING_COMPLETE , NotifyInitAppCompleteCommand);
			
			registerCommand( NOTIFY_SOCKET_INCH , NotifySocketInchCommand);
			
			registerCommand( NOTIFY_SOCKET_ENGINE_TEMP , NotifySocketEngineTempCommand);
							 
			registerCommand( NOTIFY_SOCKET_SURROUDING_TEMP , NotifySocketSurroundingTempCommand);
			
			registerCommand( NOTIFY_SOCKET_WIND , NotifySocketWindCommand);
			
			registerCommand( NOTIFY_ROPEWAY_CHANGE , NotifyRopewayChangeCommand);
						
			//概览
			registerCommand( NOTIFY_MENU_MAIN_OVERVIEW , NotifyMenuMainOverviewCommand);
						
			//张紧小尺
			registerCommand( NOTIFY_MENU_MAIN_INCH , NotifyMenuMainInchCommand);	
			
			registerCommand( NOTIFY_MENU_INCH_REALTIME , NotifyMenuInchRealtimeCommand);
			
			registerCommand( NOTIFY_MENU_INCH_ANALYSIS , NotifyMenuInchAnalysisCommand);	
			
			registerCommand( NOTIFY_MENU_INCH_MANAGER , NotifyMenuInchManagerCommand);				
						
			//动力室
			registerCommand( NOTIFY_MENU_MAIN_ENGINE_TEMP , NotifyMenuMainEngineCommand);
			
			registerCommand( NOTIFY_MENU_ENGINE_REALTIME , NotifyMenuEngineRealtimeCommand);
			
			registerCommand( NOTIFY_MENU_ENGINE_ANALYSIS , NotifyMenuEngineAnalysisCommand);
			
			registerCommand( NOTIFY_MENU_ENGINE_MANAGER , NotifyMenuEngineManagerCommand);
			
			//抱索力
			registerCommand( NOTIFY_MENU_MAIN_FORCE , NotifyMenuMainForceCommand);
			
			registerCommand( NOTIFY_PIPE_SEND_FORCE , NotifyPipeSendForceCommand);
			
			registerCommand( NOTIFY_SOCKET_FORCE_UPLOAD , NotifySocketForceUploadCommand);
		}
	}
}