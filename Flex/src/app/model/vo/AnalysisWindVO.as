package app.model.vo
{
	use namespace InternalVO;
	
	public class AnalysisWindVO extends WindValueVO implements IDateValue,IAlarmValue
	{		
		public var bracket:BracketVO;
				
		public static function facatoryCreate(jd:*):AnalysisWindVO
		{
			var result:AnalysisWindVO = new AnalysisWindVO;
			result.speed = jd.WindSpeed;
			result.dir = jd.WinDirection;
			result.date = new Date(Date.parse(jd.DeteDate));
			result.bracket = BracketVO.getName(jd.FromRopeWay,jd.Pos);
			
			return result;
		}
	}
}