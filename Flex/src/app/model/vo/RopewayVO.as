package app.model.vo
{
	[Bindable]
	public class RopewayVO
	{
		public static const ZHONG_TIAN_MEN:RopewayVO 	= new RopewayVO("中天门索道");		
		public static const TAO_HUA_YUAN:RopewayVO 		= new RopewayVO("桃花源索道");
		
		public var id:int;
		
		public var shortName:String;
				
		public var fullName:String;
		
		public function RopewayVO(value:String)
		{
			this.fullName = value;
			
			this.shortName = value.substr(0,value.indexOf("索道"));
			
			switch(value)
			{
				case "中天门索道":
					this.id = 2;
					break;
				case "桃花源索道":
					this.id = 3;
					break;
			}
		}
	}
}