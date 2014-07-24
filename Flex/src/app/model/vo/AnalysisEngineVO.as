package app.model.vo
{
	use namespace InternalVO;
	
	public class AnalysisEngineVO extends EngineTempVO implements IAlarmValue, IDateValue
	{
		public var engine:EngineVO;
		
		public static function facatoryCreate(jd:*):AnalysisEngineVO
		{
			var result:AnalysisEngineVO = new AnalysisEngineVO;
			result.temp = jd.DeteValue;
			result.date = new Date(Date.parse(jd.DeteDate));
			result.engine = EngineVO.getNamed(jd.FromRopeWay,jd.Pos);
			
			return result;
		}
	}
}