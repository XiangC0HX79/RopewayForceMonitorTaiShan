package app.model.vo
{
	use namespace InternalVO;
	
	public class WindValueAnalysisVO extends WindValueVO implements IDateValue,IAlarmValue
	{		
		public var bracket:BracketVO;
				
		public static function facatoryCreate(jd:*):WindValueAnalysisVO
		{
			var result:WindValueAnalysisVO = new WindValueAnalysisVO;
			result.speed = jd.WindSpeed;
			result.dir = jd.WinDirection;
			result.date = new Date(Date.parse(jd.DeteDate));
			result.bracket = BracketVO.getName(jd.FromRopeWay,jd.Pos);
			
			return result;
		}
	}
}