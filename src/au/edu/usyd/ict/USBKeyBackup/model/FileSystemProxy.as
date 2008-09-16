package au.edu.usyd.ict.USBKeyBackup.model
{
	import au.edu.usyd.ict.USBKeyBackup.ApplicationFacade;
	import au.edu.usyd.ict.ext.StartupManager;
	import au.edu.usyd.ict.ext.interfaces.IStartupElement;
	
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.observer.Notification;
	import org.puremvc.as3.patterns.proxy.Proxy;

	[Bindable]
	public class FileSystemProxy extends Proxy implements IProxy, IStartupElement
	{
		public static const NAME:String = "FileSystemProxy";
		
		private static const os:String = Capabilities.os.substr(0, 3).toLowerCase();
		
		private var availableFileSystems:Array = [];
		private var startupMgr:StartupManager;
		
		public function FileSystemProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, data);
			startup = new StartupManager(this);
		}
		
		public function get fileSystems():ArrayCollection
		{
			return new ArrayCollection(availableFileSystems);
		}
		
		public function updateAvailableFileSystems():void
		{
			availableFileSystems = (os=="mac") ? new File('/Volumes/').getDirectoryListing() : File.getRootDirectories() ;
			facade.notifyObservers(new Notification(ApplicationFacade.FILE_SYSTEM_UPDATE));
			
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
			ApplicationFacade.getInstance().registerProxy(this);

			updateAvailableFileSystems();
			startup.initialised = true;
						
			sendNotification(ApplicationFacade.INIT_SUCCESS, this);
		}
	}
}