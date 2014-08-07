package app
{	
	import app.controller.NotifyAverageExportDayCommand;
	import app.controller.NotifyAverageExportMonthCommand;
	import app.controller.NotifyAverageQueryDayCommand;
	import app.controller.NotifyAverageQueryMonthCommand;
	import app.controller.NotifyInitAppCommand;
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
	import app.controller.NotifyMenuMainWindCommand;
	import app.controller.NotifyMenuWindAnalysisCommand;
	import app.controller.NotifyMenuWindManagerCommand;
	import app.controller.NotifyMenuWindRealtimeCommand;
	import app.controller.NotifyRopewayChangeCommand;
	import app.controller.NotifySocketEngineCommand;
	import app.controller.NotifySocketForceCommand;
	import app.controller.NotifySocketForceUploadCommand;
	import app.controller.NotifySocketInchCommand;
	import app.controller.NotifySocketPressCommand;
	import app.controller.NotifySocketSurroundingCommand;
	import app.controller.NotifySocketWindCommand;
	import app.controller.NotifyValueChartCommand;
	import app.controller.NotifyValueExportCommand;
	import app.controller.NotifyValueTableCommand;
	import app.controller.StartupCommand;
	import app.model.AppConfigProxy;
	import app.model.AppParamProxy;
	import app.model.EngineProxy;
	import app.model.InchProxy;
	import app.model.RopewayProxy;
	import app.model.RopewayStationProxy;
	import app.model.SocketForceProxy;
	import app.model.SocketProxy;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
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
		public static const NOTIFY_SOCKET_ENGINE:String 			= "SocketEngine";
		
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
		
		public static const NOTIFY_SOCKET_PRESS:String 				= "SocketPress";
		
		public static const NOTIFY_SOCKET_SURROUDING:String 	= "SocketSurroudingTemp";
				
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
		
		public static const ACTION_UPDATE_ROPEWAY_LIST:String 			= "ActionUpdateRopewayList";			
		public static const ACTION_UPDATE_APP_PARAM:String 				= "ActionUpdateAppParam";		
		
		public static const ACTION_UPDATE_ROPEWAY:String 				= "ActionUpdateRopeway";		
						
		public static const ACTION_MAIN_PANEL_CHANGE:String 			= "ActionMainPanelChange";
		public static const ACTION_INCH_PANEL_CHANGE:String 			= "ActionInchPanelChange";
		public static const ACTION_ENGINE_PANEL_CHANGE:String 			= "ActionEnginePanelChange";
		public static const ACTION_WIND_PANEL_CHANGE:String 			= "ActionWindPanelChange";
		
		/**
		 * 主菜单-监测概览
		 **/
		public static const NOTIFY_MENU_MAIN_OVERVIEW:String 		= "MenuMainOverview";
		
		/**
		 * 主菜单-抱索力
		 **/		
		//public static const NOTIFY_CONFIG_LOADED:String 			= "SocketConfigLoaded";
		
		//public static const NOTIFY_CONFIG_FAILED:String 			= "SocketConfigFailed";
		
		//public static const NOTIFY_SOCKET_FORCE_LOADED:String 		= "SocketForceLoaded";
		
		//public static const NOTIFY_SOCKET_FORCE_FAILED:String 		= "SocketForceFailed";
		
		//public static const NOTIFY_SOCKET_LOADED:String 			= "SocketLoaded";
		
		//public static const NOTIFY_SOCKET_FAILED:String 			= "SocketFailed";
		
		//public static const NOTIFY_WIND_LOADED:String 				= "WindLoaded";
		
		//public static const NOTIFY_WIND_FAILED:String 				= "WindFailed";
				
		public static const NOTIFY_SOCKET_FORCE_INIT:String 		= "SocketForceInit";
		
		public static const NOTIFY_SOCKET_FORCE_UPLOAD:String 		= "SocketForceUpload";
		
		public static const NOTIFY_MENU_MAIN_FORCE:String 			= "MenuMainForce";
		
		public static const NOTIFY_MAIN_FORCE_INIT:String 			= "MainForceInit";
		
		public static const NOTIFY_PIPE_SEND_FORCE:String			="PipeSendForce";
		
		/**
		 * 主菜单-动力室电机温度
		 **/
		public static const NOTIFY_MENU_MAIN_ENGINE:String 			= "MenuMainEngine";		
		public static const NOTIFY_MENU_ENGINE_REALTIME:String 		= "MenuEngineRealtime";		
		public static const NOTIFY_MENU_ENGINE_ANALYSIS:String 		= "MenuEngineAnalysis";		
		public static const NOTIFY_MENU_ENGINE_MANAGER:String 		= "MenuEngineManager";
		
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
		public static const NOTIFY_MENU_WIND_REALTIME:String 		= "MenuWindRealtime";		
		public static const NOTIFY_MENU_WIND_ANALYSIS:String 		= "MenuWindAnalysis";		
		public static const NOTIFY_MENU_WIND_MANAGER:String 		= "MenuWindManager";
				
		/**
		 * 统计分析
		 **/
		public static const NOTIFY_VALUE_TABLE:String 				= "ValueTable";		
		public static const NOTIFY_VALUE_CHART:String 				= "ValueChart";		
		public static const NOTIFY_VALUE_EXPORT:String 				= "ValueExport";	
		public static const NOTIFY_AVERAGE_QUERY_DAY:String 		= "AverageQueryDay";	
		public static const NOTIFY_AVERAGE_QUERY_MONTH:String 		= "AverageQueryMonth";	
		public static const NOTIFY_AVERAGE_EXPORT_DAY:String 		= "AverageExportDay";	
		public static const NOTIFY_AVERAGE_EXPORT_MONTH:String 		= "AverageExportMonth";	
				
		/**
		 * 菜单-实时检测
		 **/
		public static const NOTIFY_MENU_REALTIME_DETECTION:String 	= "MenuRealtimeDetection";
		
		/**
		 * 菜单-实时检测
		 **/
		
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
						
			registerCommand( RopewayProxy.LOADED, LoadupResourceLoadedCommand);
			registerCommand( RopewayProxy.FAILED, LoadupResourceFailedCommand);
			registerCommand( RopewayStationProxy.LOADED, LoadupResourceLoadedCommand);
			registerCommand( RopewayStationProxy.FAILED, LoadupResourceFailedCommand);
			registerCommand( AppParamProxy.LOADED, LoadupResourceLoadedCommand);
			registerCommand( AppParamProxy.FAILED, LoadupResourceFailedCommand);
			registerCommand( EngineProxy.LOADED , LoadupResourceLoadedCommand);
			registerCommand( EngineProxy.FAILED , LoadupResourceFailedCommand);
			registerCommand( InchProxy.LOADED , LoadupResourceLoadedCommand);
			registerCommand( InchProxy.FAILED , LoadupResourceFailedCommand);
			registerCommand( AppConfigProxy.LOADED , LoadupResourceLoadedCommand);
			registerCommand( AppConfigProxy.FAILED , LoadupResourceFailedCommand);			
			registerCommand( SocketForceProxy.LOADED , LoadupResourceLoadedCommand);
			registerCommand( SocketForceProxy.FAILED , LoadupResourceFailedCommand);
			registerCommand( SocketProxy.LOADED , LoadupResourceLoadedCommand);
			registerCommand( SocketProxy.FAILED , LoadupResourceFailedCommand);
			
			registerCommand( LoadupMonitorProxy.LOADING_COMPLETE , NotifyMenuMainOverviewCommand);
			
			registerCommand( NOTIFY_SOCKET_INCH , NotifySocketInchCommand);
			
			registerCommand( NOTIFY_SOCKET_PRESS , NotifySocketPressCommand);
			
			registerCommand( NOTIFY_SOCKET_ENGINE , NotifySocketEngineCommand);
							 
			registerCommand( NOTIFY_SOCKET_SURROUDING , NotifySocketSurroundingCommand);
			
			registerCommand( NOTIFY_SOCKET_WIND , NotifySocketWindCommand);
			
			//切换索道
			registerCommand( NOTIFY_ROPEWAY_CHANGE , NotifyRopewayChangeCommand);
						
			//概览
			registerCommand( NOTIFY_MENU_MAIN_OVERVIEW , NotifyMenuMainOverviewCommand);
						
			//张紧小尺
			registerCommand( NOTIFY_MENU_MAIN_INCH , NotifyMenuMainInchCommand);	
			
			registerCommand( NOTIFY_MENU_INCH_REALTIME , NotifyMenuInchRealtimeCommand);
			
			registerCommand( NOTIFY_MENU_INCH_ANALYSIS , NotifyMenuInchAnalysisCommand);	
			
			registerCommand( NOTIFY_MENU_INCH_MANAGER , NotifyMenuInchManagerCommand);	
						
			//动力室
			registerCommand( NOTIFY_MENU_MAIN_ENGINE , NotifyMenuMainEngineCommand);
			
			registerCommand( NOTIFY_MENU_ENGINE_REALTIME , NotifyMenuEngineRealtimeCommand);
			
			registerCommand( NOTIFY_MENU_ENGINE_ANALYSIS , NotifyMenuEngineAnalysisCommand);
			
			registerCommand( NOTIFY_MENU_ENGINE_MANAGER , NotifyMenuEngineManagerCommand);
			
			//抱索力
			registerCommand( NOTIFY_MENU_MAIN_FORCE , NotifyMenuMainForceCommand);
			
			registerCommand( NOTIFY_PIPE_SEND_FORCE , NotifySocketForceCommand);
			
			registerCommand( NOTIFY_SOCKET_FORCE_UPLOAD , NotifySocketForceUploadCommand);
			
			//风速风向
			registerCommand( NOTIFY_MENU_MAIN_WIND , NotifyMenuMainWindCommand);
			
			registerCommand( NOTIFY_MENU_WIND_REALTIME , NotifyMenuWindRealtimeCommand);
			
			registerCommand( NOTIFY_MENU_WIND_ANALYSIS , NotifyMenuWindAnalysisCommand);
			
			registerCommand( NOTIFY_MENU_WIND_MANAGER , NotifyMenuWindManagerCommand);
			
			//查询统计
			registerCommand( NOTIFY_VALUE_TABLE , NotifyValueTableCommand );	
			
			registerCommand( NOTIFY_VALUE_CHART , NotifyValueChartCommand);	
			
			registerCommand( NOTIFY_VALUE_EXPORT , NotifyValueExportCommand);
			
			registerCommand( NOTIFY_AVERAGE_QUERY_DAY , NotifyAverageQueryDayCommand);			
			
			registerCommand( NOTIFY_AVERAGE_QUERY_MONTH , NotifyAverageQueryMonthCommand);
			
			registerCommand( NOTIFY_AVERAGE_EXPORT_DAY , NotifyAverageExportDayCommand);
			
			registerCommand( NOTIFY_AVERAGE_EXPORT_MONTH , NotifyAverageExportMonthCommand);
		}
	}
}