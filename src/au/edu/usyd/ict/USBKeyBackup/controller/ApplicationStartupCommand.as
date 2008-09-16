package au.edu.usyd.ict.USBKeyBackup.controller
{
	import au.edu.usyd.ict.USBKeyBackup.ApplicationFacade;
	import au.edu.usyd.ict.USBKeyBackup.model.FileSystemProxy;
	import au.edu.usyd.ict.USBKeyBackup.model.StartupProxy;
	import au.edu.usyd.ict.USBKeyBackup.view.mediator.USBKeyBackupMediator;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ApplicationStartupCommand extends SimpleCommand implements ICommand
	{
		public function ApplicationStartupCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var startupProxy:StartupProxy = new StartupProxy();
			facade.registerProxy(startupProxy);
			
			var fsProxy:FileSystemProxy = new FileSystemProxy();
			var mainMediator:USBKeyBackupMediator = new USBKeyBackupMediator(notification.getBody() as main);
			
			startupProxy.requires(fsProxy);
			startupProxy.requires(mainMediator);
			
			mainMediator.startup.requires(fsProxy);
			
			this.sendNotification(ApplicationFacade.INIT_SUCCESS, this);
			
		}
		
	}
}