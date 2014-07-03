package app.model.vo
{
	import org.puremvc.as3.multicore.utilities.flex.config.model.ConfigVO;

	public class AppConfigVO extends ConfigVO
	{		
		/**
		 * Check that config is valid.
		 */		
		override public function isValid():Boolean
		{
			// make sure deployment namespace is populated
			if ( !super.isValid() ) return false;
			
			// make sure all fields are populated
			return ( appName 	!= null &&
				appVersion 		!= null &&
				socketIp 		!= null &&
				socketPort 		!= null && 
				webserviceInfo 	!= null
			);
		}
		
		/**
		 * Get the App Name for the selected deployment environment.
		 */
		public function get appName():String
		{
			return config.nsDeploy::appName;
		}
		
		/**
		 * Get the App Version for the selected deployment environment.
		 */
		public function get appVersion():String
		{
			return config.nsDeploy::appVersion;
		}
		
		public function get socketIp():String
		{
			return config.nsDeploy::socketIp;
		}
		
		public function get socketPort():String
		{
			return config.nsDeploy::socketPort;
		}
		
		public function get webserviceInfo():String
		{
			return config.nsDeploy::webserviceInfo;
		}
	}
}