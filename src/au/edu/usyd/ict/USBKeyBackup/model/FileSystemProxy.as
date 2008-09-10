package au.edu.usyd.ict.USBKeyBackup.model
{
	import au.edu.usyd.ict.USBKeyBackup.ApplicationFacade;
	
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.core.View;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.observer.Notification;
	import org.puremvc.as3.patterns.observer.Observer;
	import org.puremvc.as3.patterns.proxy.Proxy;

	[Bindable]
	public class FileSystemProxy extends Proxy implements IProxy
	{
		public static const NAME:String = "FileSystemProxy";
		
		private static const os:String = Capabilities.os.substr(0, 3).toLowerCase();
		
		private var availableFileSystems:Array = [];
		
		public function FileSystemProxy(proxyName:String=null, data:Object=null)
		{
			super(NAME, data);
			
			View.getInstance().registerObserver(ApplicationFacade.INIT_SUCCESS,	new Observer(dependencyInitSuccess,this));
			
			//facade.notifyObservers(new Notification(ApplicationFacade.FS_PROXY_INIT_SUCCESS));
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
		
		// stuff to handle startup dependencies - will refactor this into Interface and ancestor of Proxy and Mediator
		
		private var dependencies:Dictionary = new Dictionary();
		private var initialised:Boolean = false;
		
		public function requires(obj:Object):void
		{
			// adds obj to list of required objects
			dependencies[obj] = false;
			// register interest in obj's init_success notification
			// - create an Observer instance
			// - register observer with the view
			
		}
		
		public function dependencyInitSuccess(notification:INotification):void
		{
			// get object from notification
			var obj:Object = notification.getBody();
			// check dictionary and set object status to true if present
			if (dependencies[obj] != null)
			{
			  dependencies[obj] = true;
			}
			// check to see if all dependencies are initialised
			// call init() if so
			var satisfied:Boolean = true;
			for each (var state:Boolean in dependencies)
			{
			  satisfied = satisfied && state;	
			}
			
			if (satisfied && !initialised) init();  
		}
		
		public function init():void
		{
			ApplicationFacade.getInstance().registerProxy(this);

			updateAvailableFileSystems();
			initialised = true;
						
			sendNotification(ApplicationFacade.INIT_SUCCESS, this);
		}
	}
}