package custom.other
{
	import mx.utils.ObjectUtil;

	public class CustomUtil
	{
		public static function CopyProperties(source:Object,dest:Object):void
		{
			var properties:Array = ObjectUtil.getClassInfo(source).properties as Array;
			
			for(var index:int=0;index<properties.length;index++)
			{
				var propertyName:Object = properties[index];
				if(dest.hasOwnProperty(propertyName.toString()))
				{
					dest[propertyName] = source[propertyName];
				}
			}
		}
	}
}