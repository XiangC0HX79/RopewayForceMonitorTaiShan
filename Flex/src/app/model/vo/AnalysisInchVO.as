package app.model.vo
{
	use namespace InternalVO;
	
	public class AnalysisInchVO extends InchValueVO implements IDateValue,IAlarmValue
	{		
		public var ropeway:RopewayVO;
				
		public static function facatoryCreate(jd:*):AnalysisInchVO
		{
			var result:AnalysisInchVO = new AnalysisInchVO;
			result.value = jd.DeteValue;
			result.date = new Date(Date.parse(jd.DeteDate));
			result.ropeway = RopewayVO.getNamed(jd.FromRopeWay);
			
			return result;
		}
	}
}