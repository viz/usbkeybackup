package au.edu.usyd.ict.USBKeyBackup.view.mediator
{
	import au.edu.usyd.ict.USBKeyBackup.ApplicationFacade;
	import au.edu.usyd.ict.USBKeyBackup.model.FileSystemProxy;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.core.View;
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.observer.Observer;

	public class USBKeyBackupMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "USBKeyBackupMediator";
		
		public function USBKeyBackupMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
			
			View.getInstance().registerObserver(ApplicationFacade.INIT_SUCCESS,	new Observer(dependencyInitSuccess,this));
			
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
			// this approach is inefficient - every Proxy and Mediator will receive every notification
			// if this becomes a problem, refactor this to have specific notifications for each object
			// based on a naming convention so we don't have to add all these into the ApplicationFacade
			// Then the requires(obj) function above could create a specific objserver for that object's notifications
			
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
			facade.registerMediator(this);
			initialised = true;
			
			this.sendNotification(ApplicationFacade.INIT_SUCCESS, this);
		}
		
	}
}