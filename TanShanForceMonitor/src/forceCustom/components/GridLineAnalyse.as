package forceCustom.components
{
	import forceMonitor.model.vo.RopewayForceVO;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import mx.charts.GridLines;
	import mx.charts.chartClasses.CartesianChart;
	import mx.charts.chartClasses.ChartElement;
	import mx.charts.chartClasses.ChartState;
	import mx.charts.chartClasses.GraphicsUtilities;
	import mx.charts.chartClasses.IAxisRenderer;
	import mx.charts.styles.HaloDefaults;
	import mx.core.IFlexModuleFactory;
	import mx.core.mx_internal;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import mx.graphics.Stroke;
	import mx.styles.CSSStyleDeclaration;
	
	use namespace mx_internal;
	
	public class GridLineAnalyse extends GridLines
	{
		public function GridLineAnalyse()
		{
			super();
		}
		
		/**
		 *  @private
		 */
		override protected function updateDisplayList(unscaledWidth:Number,
													  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var len:int;
			var c:Object;
			var stroke:IStroke;
			var changeCount:int;
			var ticks:Array /* of Number */;
			var spacing:Array /* of Number */;
			var axisLength:Number;
			var colors:Array /* of IFill */;
			var rc:Rectangle;
			var originStroke:IStroke;
			var addedFirstLine:Boolean;
			var addedLastLine:Boolean;
			var n:int;
			
			if (!chart||
				chart.chartState == ChartState.PREPARING_TO_HIDE_DATA ||
				chart.chartState == ChartState.HIDING_DATA)
			{
				return;
			}
						
			var colFill:Array = [];
			var colAlternateFill:Array = [];
			
			len = chart.dataProvider.length;
			var alternate:Boolean = true;
			for(var i:int = 0;i<len;i++)
			{
				var pre:RopewayForceVO = (i > 0)?chart.dataProvider[i-1]:null;
				var rf:RopewayForceVO = chart.dataProvider[i];
				if(pre && (pre.ropewayTime.toDateString() != rf.ropewayTime.toDateString()))
				{
					alternate = !alternate;
				}
				
				if(alternate)
					colAlternateFill.push(i);
				else
					colFill.push(i);
			}
			
			var g:Graphics = graphics;
			g.clear();
			
			var gridDirection:String = getStyle("gridDirection");
			if (gridDirection == "horizontal" || gridDirection == "both")
			{
				stroke = getStyle("horizontalStroke");
				
				changeCount = Math.max(1, getStyle("horizontalChangeCount"));
				if ((changeCount * 0 != 0) || changeCount <= 1)
					changeCount = 1;
				
				var verticalAxisRenderer:IAxisRenderer;
				
				if (!(CartesianChart(chart).verticalAxisRenderer))
				{
					verticalAxisRenderer = CartesianChart(chart).getLeftMostRenderer();
					if (!verticalAxisRenderer)
						verticalAxisRenderer = CartesianChart(chart).getRightMostRenderer();
				}
				else
					verticalAxisRenderer = CartesianChart(chart).verticalAxisRenderer;
				
				ticks = verticalAxisRenderer.ticks;
				
				if (getStyle("horizontalTickAligned") == false)
				{
					len = ticks.length;
					spacing = [];
					n = len;
					for(i = 1; i < n; i++)
					{
						spacing[i - 1] = (ticks[i] + ticks[i - 1]) / 2;
					}
				}
				else
				{
					spacing = ticks;
				}
				
				addedFirstLine = false;
				addedLastLine = false;
				
				if (spacing[0] != 0)
				{
					addedFirstLine = true;
					spacing.unshift(0);
				}
				
				if (spacing[spacing.length - 1] != 1)
				{
					addedLastLine = true;
					spacing.push(1);
				}
				
				axisLength = unscaledHeight;
				
				colors = [ getStyle("horizontalFill"),
					getStyle("horizontalAlternateFill") ];
				
				len = spacing.length;
				
				if (spacing[len - 1] < 1)
				{
					c = colors[1];
					if (c != null)
					{
						g.lineStyle(0, 0, 0);
						GraphicsUtilities.fillRect(g, 0, 
							spacing[len - 1] * axisLength, unscaledWidth,
							unscaledHeight, c);
					}
				}
				
				n = spacing.length;
				for (i = 0; i < n; i += changeCount)
				{
					var idx:int = len - 1 - i;
					c = colors[(i / changeCount) % 2];
					var bottom:Number = spacing[idx] * axisLength;
					var top:Number =
						spacing[Math.max(0, idx - changeCount)] * axisLength;
					rc = new Rectangle(0, top, unscaledWidth, bottom-top);
					
					if (c != null)
					{
						g.lineStyle(0, 0, 0);
						GraphicsUtilities.fillRect(g, rc.left, rc.top,
							rc.right, rc.bottom, c);
					}
					
					if (stroke && rc.bottom >= -1) //round off errors
					{
						if (addedFirstLine && idx == 0)
							continue;
						if (addedLastLine && idx == (spacing.length-1))
							continue;
						
						stroke.apply(g,null,null);
						g.moveTo(rc.left, rc.bottom);
						g.lineTo(rc.right, rc.bottom);
						
					}
				}
			}
			
			if (gridDirection == "vertical" || gridDirection == "both")
			{				
				stroke = getStyle("verticalStroke");
				changeCount = Math.max(1,getStyle("verticalChangeCount"));
				
				if (isNaN(changeCount) || changeCount <= 1)
					changeCount = 1;
				
				var horizontalAxisRenderer:IAxisRenderer;
				
				if (!(CartesianChart(chart).horizontalAxisRenderer))
				{
					horizontalAxisRenderer = CartesianChart(chart).getBottomMostRenderer();
					if (!horizontalAxisRenderer)
						horizontalAxisRenderer = CartesianChart(chart).getTopMostRenderer();
				}
				else
					horizontalAxisRenderer = CartesianChart(chart).horizontalAxisRenderer;
				
				ticks = horizontalAxisRenderer.ticks.concat();
				
				/*if (getStyle("verticalTickAligned") == false)
				{
					len = ticks.length;
					spacing = [];
					n = len;
					for (i = 1; i < n; i++)
					{
						spacing[i - 1] = (ticks[i] + ticks[i - 1]) / 2;
					}
				}
				else
				{
					spacing = ticks;
				}*/
				
				len = ticks.length;
				spacing = [];
				n = len;
				for (i = 1; i < n; i++)
				{
					spacing[i - 1] = (ticks[i] + ticks[i - 1]) / 2;
				}
				
				addedFirstLine = false;
				addedLastLine = false;
				
				if (spacing[0] != 0)
				{
					addedFirstLine = true;
					spacing.unshift(0);
				}
				
				if (spacing[spacing.length - 1] != 1)
				{
					addedLastLine = true;
					spacing.push(1);
				}
				
				axisLength = unscaledWidth;
				
				colors = [ getStyle("verticalFill"),
					getStyle("verticalAlternateFill") ];
				
				n = spacing.length;
				for (i = 0; i < n; i += changeCount)
				{
					if(colFill.indexOf(i) >=0)
						c = colors[0];
					else
						c = colors[1];
					
					var left:Number = spacing[i] * axisLength;
					var right:Number =
						spacing[Math.min(spacing.length - 1,
							i + changeCount)] * axisLength;
					rc = new Rectangle(left, 0, right - left, unscaledHeight);
					if (c != null)
					{
						g.lineStyle(0, 0, 0);
						GraphicsUtilities.fillRect(g, rc.left, rc.top,
							rc.right, rc.bottom, c);
					}
					
					/*if (stroke) // round off errors
					{
						if (addedFirstLine && i == 0)
							continue;
						if (addedLastLine && i == spacing.length-1)
							continue;
						
						stroke.apply(g,null,null);
						g.moveTo(rc.left, rc.top);
						g.lineTo(rc.left, rc.bottom);
					}*/
				}
			}
			
			var horizontalShowOrigin:Object = getStyle("horizontalShowOrigin");
			var verticalShowOrigin:Object = getStyle("verticalShowOrigin");
			
			if (verticalShowOrigin || horizontalShowOrigin)
			{
				var cache:Array /* of Object */ = [ { xOrigin: 0, yOrigin: 0 } ];
				var sWidth:Number = 0.5;
				
				dataTransform.transformCache(cache, "xOrigin", "x", "yOrigin", "y");
				
				if (horizontalShowOrigin &&
					cache[0].y > 0 && cache[0].y < unscaledHeight)
				{
					originStroke = getStyle("horizontalOriginStroke");
					originStroke.apply(g,null,null);
					g.moveTo(0, cache[0].y - sWidth / 2);
					g.lineTo($width, cache[0].y - sWidth / 2);
				}
				
				if (verticalShowOrigin &&
					cache[0].x > 0 && cache[0].x < unscaledWidth)
				{
					originStroke = getStyle("verticalOriginStroke");
					originStroke.apply(g,null,null);
					g.moveTo(cache[0].x - sWidth / 2, 0);
					g.lineTo(cache[0].x - sWidth / 2, $height);
				}
			}
		}
	}
}