package app.model.vo
{
	public interface IAveValue
	{		
		function get minValue():Number;
		function set minValue(value:Number):void;
		
		function get maxValue():Number;
		function set maxValue(value:Number):void;
		
		function get aveValue():Number;
		function set aveValue(value:Number):void;
	}
}