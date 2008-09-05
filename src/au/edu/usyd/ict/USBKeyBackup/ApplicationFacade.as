package au.edu.usyd.ict.USBKeyBackup
{
	import au.edu.usyd.ict.USBKeyBackup.controller.ApplicationStartupCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade implements IFacade
	{
		// General definitions
		
		// general application notifications
		public static const APP_STARTUP:String = "AppStartup";

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