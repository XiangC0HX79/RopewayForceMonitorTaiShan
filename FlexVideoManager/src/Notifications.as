package
{
	public final class Notifications
	{
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
		
		public static const INIT_BEGIN:String 						= "InitBegin";
		
		public static const INIT_END:String 						= "InitEnd";
		
		public static const INIT_DATA_AREA:String 					= "InitDataArea";
		
		public static const INIT_DATA_VIDEO:String 					= "InitDataVideo";
		
		public static const INIT_VIEW_IMAGE:String 					= "InitViewImage";
				
		public static const IMAGE_GROUP_REFRESH:String 				= "ImageGroupRefresh";
		
		public static const IMAGE_GROUP_ZOOMIN:String 				= "ImageGroupZoomIn";
		
		public static const IMAGE_GROUP_ZOOMOUT:String 				= "ImageGroupZoomOut";
		
		public static const IMAGE_GROUP_ZOOMCONTENT:String 			= "ImageGroupZoomContent";
		
		public static const IMAGE_GROUP_ZOOMREAL:String 			= "ImageGroupZoomReal";
		
		public static const VIDEO_SHOW_TIP:String 					= "VideoShowTip";
		
		public static const VIDEO_IMAGE_MOVE:String 				= "VideoImageMove";
		
		public static const APP_RESIZE:String 						= "AppResize";
	}
}