package custom.other
{
	import spark.effects.interpolation.NumberInterpolator;
	
	public class IntInterpolator extends NumberInterpolator
	{		
		public function IntInterpolator()  
		{  
			super();  
		}  
				
		override public function interpolate(fraction:Number, startValue:Object, endValue:Object):Object  
		{  
			return int(startValue) + Math.round((int(endValue) - int(startValue)) * fraction);  
		}  
	}
}