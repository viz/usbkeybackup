package au.edu.usyd.ict.USBKeyBackup.view.mediator
{
	import au.edu.usyd.ict.USBKeyBackup.ApplicationFacade;
	import au.edu.usyd.ict.USBKeyBackup.model.FileSystemProxy;
	import au.edu.usyd.ict.ext.StartupManager;
	import au.edu.usyd.ict.ext.interfaces.IStartupElement;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class USBKeyBackupMediator extends Mediator implements IMediator, IStartupElement
	{
		public static const NAME:String = "USBKeyBackupMediator";
		
		private var startupMgr:StartupManager;
		
		public function USBKeyBackupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			startup = new StartupManager(this);
			
		}
		
		public function get usbKeyBackup():main
		{
			return viewComponent as main;
		}
		
		override public function listNotificationInterests():Array
		{
			return [ ApplicationFacade.APP_STARTUP_SUCCESS ];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case ApplicationFacade.APP_STARTUP_SUCCESS:
				    usbKeyBackup.driveList.dataProvider = (facade.retrieveProxy(FileSystemProxy.NAME) as FileSystemProxy).fileSystems;
				    break;
			}
		}
		
		override public function onRegister():void
		{
		}
		
		override public function onRemove():void
		{
		}
		
		public function get startup():StartupManager
		{
			return startupMgr;
		}
		
		public function set startup(mgr:StartupManager):void
		{
			startupMgr = mgr;
		}
		
		public function init():void
		{
			facade.registerMediator(this);
			startup.initialised = true;
			
			sendNotification(ApplicationFacade.INIT_SUCCESS, this);
		}
		
	}
}