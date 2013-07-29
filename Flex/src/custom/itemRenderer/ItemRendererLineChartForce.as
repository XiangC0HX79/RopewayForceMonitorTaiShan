package custom.itemRenderer
{
	import app.model.vo.RopewayForceVO;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import mx.charts.ChartItem;
	import mx.core.IDataRenderer;
	import mx.graphics.IFill;
	import mx.graphics.SolidColor;
	import mx.skins.ProgrammaticSkin;
	
	public class ItemRendererLineChartForce extends ProgrammaticSkin
		implements IDataRenderer
	{		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		private static var rcFill:Rectangle = new Rectangle();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function ItemRendererLineChartForce() 
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  data
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage for the data property.
		 */
		private var _data:Object;
		
		[Inspectable(environment="none")]
		
		/**
		 *  The chartItem that this itemRenderer displays.
		 *  This value is assigned by the owning series.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get data():Object
		{
			return _data;
		}
		
		/**
		 *  @private
		 */
		public function set data(value:Object):void
		{
			if (_data == value)
				return;
			
			_data = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var fill:IFill;
			
			var state:String = "";
			
			//trace( _data.currentState);
						
			var color:uint;
			var adjustedRadius:Number = 0;
			
			/*switch (state)
			{
				case ChartItem.FOCUSED:
				case ChartItem.ROLLOVER:
					if (styleManager.isValidStyleValue(getStyle('itemRollOverColor')))
						color = getStyle('itemRollOverColor');
					else
						color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),-20);
					fill = new SolidColor(color);
					adjustedRadius = getStyle('adjustedRadius');
					if (!adjustedRadius)
						adjustedRadius = 0;
					break;
				case ChartItem.DISABLED:
					if (styleManager.isValidStyleValue(getStyle('itemDisabledColor')))
						color = getStyle('itemDisabledColor');
					else
						color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),20);
					fill = new SolidColor(GraphicsUtilities.colorFromFill(color));
					break;
				case ChartItem.FOCUSEDSELECTED:
				case ChartItem.SELECTED:
					if (styleManager.isValidStyleValue(getStyle('itemSelectionColor')))
						color = getStyle('itemSelectionColor');
					else
						color = ColorUtil.adjustBrightness2(GraphicsUtilities.colorFromFill(fill),-30);
					fill = new SolidColor(color);
					adjustedRadius = getStyle('adjustedRadius');
					if (!adjustedRadius)
						adjustedRadius = 0;
					break;
			}*/
												
			if((_data.item is RopewayForceVO) && (_data.item.alarm > 0))
				fill = new SolidColor(0xFF0000);
			else
				fill = new SolidColor(0x02C462);
			
			rcFill.right = unscaledWidth;
			rcFill.bottom = unscaledHeight;
			
			var g:Graphics = graphics;
			g.clear();		
			
			if (fill)
				fill.begin(g, rcFill, null);
			
			g.drawEllipse(0,0,unscaledWidth, unscaledHeight);
			
			if (fill)
				fill.end(g);
		}
		
	}
}