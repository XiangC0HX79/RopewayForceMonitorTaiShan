package test.model
{
	import app.model.vo.InternalVO;
	import app.model.vo.RopewayStationVO;
	import app.model.vo.RopewayVO;
	
	import flexunit.framework.Assert;

	use namespace InternalVO;
	
	public class RopewayStationVOTest
	{		
		[Before]
		public function setUp():void
		{
			RopewayVO.loadRopeway();
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function getNamedTest():void
		{
			Assert.assertTrue(RopewayStationVO.getNamed("后十五驱动站").fullName == ("Null" +  RopewayStationVO.FIRST));
			
			Assert.assertTrue(RopewayStationVO.getNamed("后十五回回站").fullName == ("Null" +  "Station"));
		}
		
	}
}