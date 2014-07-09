package app.model.vo
{
	use namespace InternalVO;
	
	[Bindable]
	public class WindAverageAnalysisVO
	{
		public var date:Date;
		
		public var bracket:BracketVO;
		
		public var maxSpeed:int;
		
		public var minSpeed:int;
		
		public var aveSpeed:int;
		
		public static function facatoryCreate(jd:*):WindAverageAnalysisVO
		{
			var result:WindAverageAnalysisVO = new WindAverageAnalysisVO;
			result.maxSpeed = jd.MaxWindSpeed;
			result.minSpeed = jd.MinWindSpeed;
			result.aveSpeed = jd.AvgWindSpeed;
			result.date = new Date(Date.parse(jd.DeteDate));
			result.bracket = BracketVO.getName(jd.FromRopeWay,jd.Pos);
			
			return result;
		}
	}
}