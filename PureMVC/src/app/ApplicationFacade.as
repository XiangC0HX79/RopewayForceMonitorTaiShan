package app
{
	import app.controller.StartupCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	import spark.components.Application;
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		public static const STARTUP:String 							= "startup";
		/**显示等待
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>String</td><td>显示内容</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_MAIN_LOADING_SHOW:String 		= "MainLoadingShow";
		
		/**隐藏等待
		 **/
		public static const NOTIFY_MAIN_LOADING_HIDE:String 		= "MainLoadingHide";
		
		/**配置信息初始化完成
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>ConfigVO</td><td>配置信息</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_INIT_CONFIG_COMPLETE:String 		= "InitConfigComplete";
		
		/**提示错误
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
		/**读取滚轮数据完成
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>arrayc</td><td>所有支架信息</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_INIT_STAND_COMPLETE:String				= "InitStandComplete";
		/**读取滚轮数据完成
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>RopewayVO</td><td>最后一个滚轮信息</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_INIT_WHEEL_COMPLETE:String				= "InitWheelComplete";
		/**切换索道
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>string</td><td>索道名</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_INIT_MAINTAINTYPE_COMPLETE:String				= "InitMaintainTypeComplete";
		
		public static const NOTIFY_INIT_STATION_CHANGE:String				= "InitStationChange";
		
		/**程序初始化完成
		 **/
		public static const NOTIFY_INIT_APP_COMPLETE:String 		= "InitAppComplete";
		
		
		/**菜单-实时检测
		 **/
		public static const NOTIFY_MENU_MAINCONENT:String 	= "MenuRealtimeDetection";
		
		/**菜单-滚轮设置
		 **/
		public static const NOTIFY_MENU_MANAGE:String 		= "MenuManage";
		/**添加支架完成
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>string</td><td>支架名</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ADD_STAND_COMPLETE:String  = "AddStandComplete";
		/**弹出区域详细窗口
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>区域编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_NEW_AREA_WINDOWS:String  = "NewAreaWindow";
		
		public static const NOTIFY_ADD_AREA_WINDOWS:String  = "AddAreaWindow";
		/**读取区域滚轮数据完成
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>arr</td><td>滚轮数据</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_AREAWHEEL_COMPLETE:String  = "AreaWheelComplete";
		/**读取滚轮历史维护数据完成
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>arr</td><td>滚轮数据</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_WHEELHISTORY_COMPLETE:String  = "WheelHistoryComplete";
		/**添加编辑滚轮维护信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>区域编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ADD_MAINTAIN:String  = "AddMaintain";
		
		/**删除滚轮维护信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>区域编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_DELETE_MAINTAIN:String  = "DeleteMaintain";
		/**读取滚轮数据完成
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>区域id</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_WHEELMANAGE_COMPLETE:String  = "WheelManageComplete";
		/**添加滚轮
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>区域编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ADD_WHEELMANAGE:String  = "AddWheelManage";
		
		/**删除滚轮维护信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>区域编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_DELETE_WHEELMANAGE:String  = "DeleteWheelManage";
		
		/**读取滚轮信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>区域编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_WHEELLIST_COMPLETE:String  = "WheelListComplete";
		/**刷新滚轮信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>区域编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_WHEEL_REFRESH:String  = "WheelRefresh";
		/**获得报警信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>区域编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_WARNING_GET:String  = "WarningGet";
		
		/**定位区域
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>区域编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_LOCATE_AREA:String  = "LocateArea";
		
		/**定位滚轮所在区域
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>string</td><td>滚轮编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_LOCATE_WHEEL:String  = "LocateWheel";
		
		/**弹出支架信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>支架编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ADD_STAND_WINDOWS:String  = "AddStandWindow";
		
		/**获取支架信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>StandBaseinfoVO</td><td>支架信息</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_INIT_STANDINFO:String  = "InitStandInfo";
		
		/**获取支架维护信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>StandMaintainVO</td><td>支架信息</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_INIT_STANDMAINTAIN:String  = "InitStandMaintain";
		
		/**弹出支架维护信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>支架编号</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_STANDMAINTAIN_WINDOWS:String  = "StandMaintainWindow";
		
		/**获取支架模板信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>StandMaintainVO</td><td>支架信息</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_INIT_STANDCONFIG:String  = "InitStandConfig";
		
		/**添加支架详细维护信息
		 * <p></p>
		 * <table>
		 * 	<th>参数类型</th><th>参数说明</th>
		 * 	<tr>
		 *    <td>int</td><td>支架维护信息ID</td>
		 * 	</tr>
		 * </table>
		 **/
		public static const NOTIFY_ADD_MAINTAINDATA:String  = "AddMaintainData";
		
		public static const NOTIFY_TITLEWINDOW_PROJECT_SHOW:String  = "TitleWindowProjectShow";
		
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