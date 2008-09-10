package au.edu.usyd.ict.USBKeyBackup
{
	import au.edu.usyd.ict.USBKeyBackup.controller.ApplicationStartupCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade implements IFacade
	{
		// General definitions
		public static const INIT_SUCCESS:String = "InitSuccess";
		
		// general application notifications
		public static const APP_STARTUP:String = "AppStartup";
		public static const APP_STARTUP_SUCCESS:String = "AppStartupComplete";
		public static const FS_PROXY_INIT_SUCCESS:String = "FSProxyInitSuccess";
		public static const FILE_SYSTEM_UPDATE:String = "FileSystemUpdate";

        public static function getInstance():ApplicationFacade
        {
            if (instance==null) instance = new ApplicationFacade();
            
            return instance as ApplicationFacade;
        }
        
        override protected function initializeController():void
        {
            super.initializeController();
            this.registerCommand(APP_STARTUP, ApplicationStartupCommand);
        }
		
	}
}