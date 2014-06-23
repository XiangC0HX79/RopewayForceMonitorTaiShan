package forceMonitor
{
	import forceMonitor.controller.StartupCommand;
	
	import org.puremvc.as3.multicore.interfaces.IFacade;
	import org.puremvc.as3.multicore.patterns.facade.Facade;
	
	public class ForceMonitorFacade extends Facade implements IFacade
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
		public static const NOTIFY_INIT_ROPEWAY_COMPLETE:String 	= "InitRopewayComplete";
				
		/**
		 * 程序初始化完成
		 **/
		public static const NOTIFY_INIT_APP_COMPLETE:String 		= "InitAppComplete";
		
		public static const NOTIFY_UNLOAD_APPE:String 				= "UnloadApp";
				
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
		
		public static const NOTIFY_PIPE_SEND_FORCE:String 			= "PipeSendForce";
		
		/**
		 * 报警实时信息
		 **/
		public static const NOTIFY_ROPEWAY_ALARM_REALTIME:String 	= "RopewayAlarmRealtime";
		
		/**
		 * 站点改变
		 **/
		public static const NOTIFY_MAIN_STATION_CHANGE:String 		= "MainGroupChange";
		
		/**
		 * 分析表改变
		 **/
		public static const NOTIFY_MAIN_ANALYSIS_CHANGE:String 		= "MainGroupAnalysisChange";
		
		/**
		 * 设置改变
		 **/
		public static const NOTIFY_MAIN_MANAGER_CHANGE:String 		= "MainGroupMangerChange";
		
		/**
		 * 菜单-实时检测
		 **/
		public static const NOTIFY_MENU_REALTIME_DETECTION:String 	= "MenuRealtimeDetection";
		
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
		
		public function ForceMonitorFacade(key:String)
		{
			super(key);
		}
		
		/**
		 * Singleton ApplicationFacade Factory Method
		 */
		public static function getInstance(key:String) : ForceMonitorFacade 
		{
			if ( instanceMap[ key ] == null ) instanceMap[ key ] = new ForceMonitorFacade( key);
			return instanceMap[ key ] as ForceMonitorFacade;
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